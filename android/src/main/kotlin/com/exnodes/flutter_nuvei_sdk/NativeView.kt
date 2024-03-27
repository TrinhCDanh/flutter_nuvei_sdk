    package com.exnodes.flutter_nuvei_sdk

    import android.content.Context
    import android.view.LayoutInflater
    import android.view.View
    import android.widget.EditText
    import android.widget.TextView
    import com.exnodes.flutter_nuvei_sdk.R
    import com.nuvei.sdk.views.nuveifields.NuveiCreditCardField
    import io.flutter.plugin.platform.PlatformView

    internal class NativeView(private val context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {
        private val view: View = LayoutInflater.from(context).inflate(R.layout.fragment_payment, null)

        override fun getView(): View {
            return view
        }

        override fun dispose() {
            // Clean up resources if needed
        }
        init {
            val creditCardField = view.findViewById(R.id.creditCardField) as NuveiCreditCardField
            with(creditCardField) {
                creditCardField.onInputUpdated = { hasFocus ->
                    val cardNumber = findViewById<EditText>(R.id.numberEditText)
                    val cardHolderName = findViewById<EditText>(R.id.holderNameEditText)
                    val expiryDate = findViewById<EditText>(R.id.expiryEditText)
                    val cvv = findViewById<EditText>(R.id.cvvEditText)
                    println("Cardholder Name: ${cardHolderName.text}")
                    println("Card Number: ${cardNumber.text}")
                    println("Expiry Date: ${expiryDate.text}")
                    println("CVV: ${cvv.text}")
                }

                creditCardField.onInputValidated = { errors ->
                    val numberErrorTextView = view.findViewById<TextView>(R.id.numberErrorTextView)
                    val cardHolderNameErrorTextView = view.findViewById<TextView>(R.id.holderNameErrorTextView)
                    val expiryDateErrorTextView = view.findViewById<TextView>(R.id.expiryErrorTextView)
                    val cvvErrorTextView = view.findViewById<TextView>(R.id.cvvErrorTextView)

                    println("Validated Cardholder Name: ${cardHolderNameErrorTextView.text}")
                    println("Validated Card Number: ${numberErrorTextView.text}")
                    println("Validated Expiry Date: ${expiryDateErrorTextView.text}")
                    println("Validated CVV: ${cvvErrorTextView.text}")
                }
            }
        }
    }