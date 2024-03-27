    package com.exnodes.flutter_nuvei_sdk

    import android.content.Context
    import android.graphics.Color
    import android.view.LayoutInflater
    import android.view.View
    import android.widget.EditText
    import android.widget.TextView
    import com.nuvei.sdk.model.NuveiFieldCustomization
    import com.nuvei.sdk.model.NuveiLabelCustomization
    import com.nuvei.sdk.model.NuveiTextBoxCustomization
    import com.nuvei.sdk.views.nuveifields.NuveiCreditCardField
    import io.flutter.plugin.common.MethodChannel
    import io.flutter.plugin.platform.PlatformView

    internal class NativeView(
        private val context: Context,
        id: Int,
        creationParams: Map<String?, Any?>?,
        private val methodChannel: MethodChannel,
        private val cardDataCallback: CardDataCallback
    ) : PlatformView {
        private val view: View = LayoutInflater.from(context).inflate(R.layout.fragment_payment, null)

        override fun getView(): View {
            return view
        }

        override fun dispose() {
            // Clean up resources if needed
        }
        init {
            val creditCardField = view.findViewById(R.id.creditCardField) as NuveiCreditCardField

            val customization = NuveiFieldCustomization(
                backgroundColor = Color.WHITE,
                borderColor = Color.WHITE,
                cornerRadius = 2,
                borderWidth = 1,
                labelCustomization = NuveiLabelCustomization(
                    textFontSize = 12,
                    textColor = Color.parseColor("#49516F"),
                ),
                textBoxCustomization = NuveiTextBoxCustomization(
                    textFontSize = 14,
                    textColor = Color.BLACK,
                    borderColor = Color.BLACK,
                ),
                errorLabelCustomization = NuveiLabelCustomization(
                    textFontSize = 12,
                    textColor = Color.parseColor("#E02D3C")
                )
            )
            creditCardField.applyCustomization(customization)

            with(creditCardField) {
                creditCardField.onInputUpdated = { hasFocus ->
                    methodChannel.invokeMethod("onInputUpdated", hasFocus.toString())
                }

                creditCardField.onInputValidated = { errors ->
                    val numberErrorTextView = view.findViewById<TextView>(R.id.numberErrorTextView)
                    val cardHolderNameErrorTextView = view.findViewById<TextView>(R.id.holderNameErrorTextView)
                    val expiryDateErrorTextView = view.findViewById<TextView>(R.id.expiryErrorTextView)
                    val cvvErrorTextView = view.findViewById<TextView>(R.id.cvvErrorTextView)
                    val hasError: Boolean = numberErrorTextView.text.isNotEmpty() || cardHolderNameErrorTextView.text.isNotEmpty() || expiryDateErrorTextView.text.isNotEmpty() || cvvErrorTextView.text.isNotEmpty()
                    methodChannel.invokeMethod("onInputValidated", hasError.toString())
                }
            }

            val cardNumber = view.findViewById<EditText>(R.id.numberEditText)
            val cardHolderName = view.findViewById<EditText>(R.id.holderNameEditText)
            val expiryDate = view.findViewById<EditText>(R.id.expiryEditText)
            val cvv = view.findViewById<EditText>(R.id.cvvEditText)
            cardDataCallback.invoke(creditCardField, cardNumber, cardHolderName, expiryDate, cvv)
        }
    }