package com.range.takk

import android.content.Intent
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import androidx.annotation.NonNull
import androidx.fragment.app.Fragment
import com.stripe.android.ApiResultCallback
import com.stripe.android.PaymentConfiguration
import com.stripe.android.SetupIntentResult
import com.stripe.android.Stripe
import com.stripe.android.googlepaylauncher.GooglePayEnvironment
import com.stripe.android.googlepaylauncher.GooglePayLauncher
import com.stripe.android.model.ConfirmSetupIntentParams
import com.stripe.android.model.PaymentMethod
import com.stripe.android.model.StripeIntent
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.math.BigInteger
import java.security.MessageDigest


class MainActivity : FlutterFragmentActivity() {

    private lateinit var stripe: Stripe
    private lateinit var promise: MethodChannel.Result
    private var googlePayLauncher: GooglePayLauncher? = null
    private val PUBLISHABLE_KEY: String =
        "sk_live_6TYhmmwfCRaQQLMoMNOShR7z00ICWUmANK"
    private var isPay: Boolean = true

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        stripe = Stripe(this, PUBLISHABLE_KEY)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.range.takk/callIntent"
        ).setMethodCallHandler { call, result ->
            promise = result
            when (call.method) {
                "stripeAddCard" -> {
                    val cardDialog: StripeDialog = StripeDialog.newInstance("Add Card", null)
                    cardDialog.stripeInstance = stripe
                    cardDialog.tokenListener = object : Function1<PaymentMethod, Unit> {
                        override fun invoke(p1: PaymentMethod) {
                            val map = HashMap<String, Any?>()
                            map["id"] = p1.id
                            map["last4"] = p1.card?.last4
                            result.success(map)
                        }
                    }
                    cardDialog.show(fragmentManager, "AddNewCard")
                }
                "confirmSetupIntent" -> {
                    val csip = ConfirmSetupIntentParams.create(
                        call.argument<String>("paymentMethodId")!!,
                        call.argument<String>("clientSecret")!!
                    )
                    stripe.confirmSetupIntent(this@MainActivity, csip)
                }
                "nativePay" -> {
                    if (googlePayLauncher != null) {
                        if (isPay) {
                            kotlin.runCatching {
                                googlePayLauncher?.presentForPaymentIntent(call.argument<String>("clientSecret")!!)
                            }.onFailure {
                                val map = HashMap<String, String>()
                                map["err"] = it.localizedMessage?:""
                                result.success(map)
                            }
                        }
                        else {
                            val map = HashMap<String, String>()
                            map["err"] = "You cannot pay from Google Pay for now"
                            result.success(map)
                        }
                    }
                }
                "isGooglePay" -> {
                    result.success(isPay)
                }
                "getSigningCertSha1" -> {
                    try {
                        val info: PackageInfo = packageManager.getPackageInfo(call.arguments<String>()!!, PackageManager.GET_SIGNATURES)
                        for (signature in info.signatures) {
                            val md: MessageDigest = MessageDigest.getInstance("SHA1")
                            md.update(signature.toByteArray())

                            val bytes: ByteArray = md.digest()
                            val bigInteger = BigInteger(1, bytes)
                            val hex: String = String.format("%0" + (bytes.size shl 1) + "x", bigInteger)

                            result.success(hex)
                        }
                    } catch (e: Exception) {
                        result.error("ERROR", e.toString(), null)
                    }
                }
            }
        }
    }

    override fun onStart() {
        super.onStart()
        PaymentConfiguration.init(this, PUBLISHABLE_KEY)
        googlePayLauncher = GooglePayLauncher(
            activity = this,
            config = GooglePayLauncher.Config(
                environment = GooglePayEnvironment.Test,
                merchantCountryCode = "US",
                merchantName = "Takk, Inc",
                billingAddressConfig = GooglePayLauncher.BillingAddressConfig(
                    isRequired = true,
                    format = GooglePayLauncher.BillingAddressConfig.Format.Full,
                    isPhoneNumberRequired = true
                )
            ),
            readyCallback = ::onGooglePayReady,
            resultCallback = ::onGooglePayResult
        )
    }

    private fun onGooglePayReady(isReady: Boolean) {
        isPay = isReady
    }

    private fun onGooglePayResult(result: GooglePayLauncher.Result) {
        val map = HashMap<String, Any?>()
        when (result) {
            is GooglePayLauncher.Result.Completed -> {
                map["success"] = "Succeeded"
                promise.success(map)
            }
            GooglePayLauncher.Result.Canceled -> {
                map["err"] = "Canceled"
                promise.success(map)
            }
            is GooglePayLauncher.Result.Failed -> {
                map["err"] = result.error
                promise.success(map)
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (stripe.isSetupResult(requestCode, data)) {
            stripe.onSetupResult(requestCode, data, object :
                ApiResultCallback<SetupIntentResult> {
                override fun onError(e: Exception) {
                    promise.error("err", e.message, null)
                }

                override fun onSuccess(result: SetupIntentResult) {
                    val paymentIntent = result.intent
                    val status = paymentIntent.status
                    val map = HashMap<String, Any?>()
                    if (status == StripeIntent.Status.Succeeded) {
                        map["success"] = "Succeeded"
                        promise.success(map)
                    } else if (status == StripeIntent.Status.RequiresAction || status == StripeIntent.Status.RequiresPaymentMethod) {
                        map["err"] = "The user failed authentication."
                        promise.success(map)
                    } else {
                        map["err"] = "Unknown error"
                        promise.success(map)
                    }
                }
            })
        }
    }

}
