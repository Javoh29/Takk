package com.range.takk

import android.app.DialogFragment
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import com.stripe.android.ApiResultCallback
import com.stripe.android.Stripe
import com.stripe.android.model.PaymentMethod
import com.stripe.android.model.PaymentMethodCreateParams
import com.stripe.android.view.CardMultilineWidget

class StripeDialog : DialogFragment() {
    lateinit var mCardInputWidget: CardMultilineWidget
    lateinit var stripeInstance: Stripe
    lateinit var progress: View
    lateinit var buttonSave: View
    var tokenListener: ((PaymentMethod) -> (Unit))? = null

    companion object {
        @JvmStatic
        fun newInstance(title: String, stripeAccountId: String?): StripeDialog {
            val frag = StripeDialog()
            val args = Bundle()
            args.putString("stripeAccountId", stripeAccountId)
            args.putString("title", title)
            frag.arguments = args
            return frag
        }

    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.activity_stripe, container)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setStyle(STYLE_NO_TITLE, R.style.DialogTheme)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val title = arguments?.getString("title", "Add Source")
        dialog?.setTitle(title)

        mCardInputWidget = view.findViewById(R.id.card_input_widget) as CardMultilineWidget
        mCardInputWidget.setShouldShowPostalCode(false)
        progress = view.findViewById(R.id.progress)
        buttonSave = view.findViewById(R.id.buttonSave)
        view.findViewById<View>(R.id.buttonSave)?.setOnClickListener {
            getToken()
        }
    }

    private fun getToken() {
        if (mCardInputWidget.validateAllFields()) {
            mCardInputWidget.paymentMethodCreateParams?.let { params ->
                mCardInputWidget.paymentMethodCard?.let { card ->
                    progress.visibility = View.VISIBLE
                    buttonSave.visibility = View.GONE
                    val paymentMethodCreateParams = PaymentMethodCreateParams.create(
                        card,
                        PaymentMethod.BillingDetails.Builder().build()
                    )

                    stripeInstance.createPaymentMethod(
                        paymentMethodCreateParams,
                        null,
                        arguments?.getString("stripeAccountId", null),
                        object : ApiResultCallback<PaymentMethod> {
                            override fun onSuccess(result: PaymentMethod) {
                                progress.visibility = View.GONE
                                buttonSave.visibility = View.GONE

                                tokenListener?.invoke(result)
                                dismiss()
                            }

                            override fun onError(error: Exception) {
                                progress.visibility = View.GONE
                                buttonSave.visibility = View.VISIBLE
                                view?.let {
                                    Toast.makeText(
                                        it.context,
                                        error.localizedMessage,
                                        Toast.LENGTH_LONG
                                    )
                                        .show()
                                }
                            }

                        })
                }
            }
        } else {
            view?.let {
                Toast.makeText(
                    it.context,
                    "The card info you entered is not correct",
                    Toast.LENGTH_LONG
                )
                    .show()
            }
        }

    }
}