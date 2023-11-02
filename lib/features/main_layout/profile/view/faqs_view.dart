import 'package:eds_beta/common/components/title_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class FAQsView extends StatelessWidget {
  const FAQsView({super.key});

  final String _faqs = '''
# Frequently Asked Questions

## Account Registration
**How can I create an account?**

A. You can use your phone number to log into your account by verifying through OTP.

##
## Order & Shopping
**How to place an order?**

A. You can order a product by selecting the product, adding it to your cart, and proceeding with the order.

**What payment methods do you accept?**

A. We accept UPI payments, cards, and Cash on Delivery (COD).

**How to track an order?**

A. We will provide a shipment ID so you can track it through our delivery partner's website or application.

**Can I change or cancel the order?**

A. Once the product has been dispatched, you cannot modify the order. You can cancel the order with a proper reason; otherwise, you won't be eligible for COD.

##
## Shipping & Delivery
**Shipping cost & time?**

A. Shipping time is usually 6 working days upon ordering. Delivery price and availability will be shown before finalizing the order.

**What if my order is delayed or lost in transit?**

A. In some circumstances, your order may get delayed. In that case, you can contact our support team, and they will help you get your order delivered to you, or you can raise a request for a refund.

**How can I return my order? (Please do add it in our policies)**
A. To return an order, you have to provide a valid reason, such as if the product doesn't match the description or if the product has a manufacturing defect or is damaged. To return a product, you should have all the box contents, the bill, and the box.

##
## Return and Refund
**Return period?**

A. In order to return a product, you should follow our return policy. When it complies with our policy, you have to raise a return request within two days after receiving the order.

**How to return?**

A. You can return by raising a request in your order history by selecting the product you want to return and choosing the return option.

**When will I receive my refund?**

A. Once the product has been picked up, you will get your refund within three working days.

**How long is the return period applicable?**

A. 3 days

##
## Account Management
**How can I update my personal information in the app?**

A. You can update your profile information and delivery address through the "Edit Profile" option in the profile section of the app.

**Is there any tutorial of app functionality?**

A. You can watch app tutorials on our official YouTube channel.

**How to contact customer care?**

A. To contact us, you can email us at [endlessstore.in.co@gmail.com](mailto:endlessstore.in.co@gmail.com).


''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: titleAppBar(title: "FAQs"),
      body: Markdown(
        data: _faqs,
      ),
    );
  }
}
