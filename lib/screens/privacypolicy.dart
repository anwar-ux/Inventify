

import 'package:flutter/material.dart';


class Privacypolicy extends StatelessWidget {
  const Privacypolicy({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Theme.of(context).colorScheme.background,
          child: const SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy Policy',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Last updated: March 06, 2024',
                  style: TextStyle(fontSize: 14,color: Colors.grey),
                ),
                SizedBox(height: 16),
                Text(
                  'Welcome to IVENTIFY! This Privacy Policy is here to inform you about how we, at IVENTIFY, collect, use, and disclose your information when you use our service. It outlines your privacy rights and the legal protections in place to safeguard your data.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Interpretation and Definitions:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'We provide definitions for key terms used throughout this policy, ensuring a clear understanding.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Collecting and Using Your Personal Data:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Types of Data Collected:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Personal Data: We may ask for your email address, first name, last name, and usage data. Usage Data: Information collected automatically during your use of IVENTIFY, including your device\'s IP address, browser type, and pages visited.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Information Collected while Using the Application:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'We may request access to your device\'s camera and photo library to provide features within the IVENTIFY application.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Use of Your Personal Data:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'We use your information to provide, maintain, and enhance the IVENTIFY service. This includes managing your account, complying with contractual agreements, and contacting you for updates or informative communications.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Sharing Your Personal Information:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'We may share your personal information with Service Providers, Affiliates, business partners, and other users, always with your consent.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Retention and Transfer of Your Personal Data:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'We retain your data for as long as necessary, ensuring compliance with legal obligations. Your information may be transferred to and processed outside your jurisdiction, adhering to data protection laws.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Delete Your Personal Data:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'You have the right to request the deletion of your personal data. Instructions on how to do this are available within the IVENTIFY service.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Disclosure of Your Personal Data:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'In case of business transactions, mergers, acquisitions, or legal obligations, we may transfer your personal data. We ensure transparency and notice in such situations.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Security of Your Personal Data:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'While we employ commercially acceptable means to protect your data, absolute security over the Internet cannot be guaranteed.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Children\'s Privacy:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'IVENTIFY is not intended for users under the age of 13. If your child has provided personal data, please contact us. Parental consent may be required in certain jurisdictions.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Links to Other Websites:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'External links within IVENTIFY may lead to third-party websites. Review their privacy policies as we have no control over their content or practices.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Changes to this Privacy Policy:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'We may update this policy, and any changes will be communicated via email or through prominent notices on IVENTIFY. Regularly review this policy for updates.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Contact Us:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'If you have any questions about this Privacy Policy, contact us at inventify07@gmail.com',
                  style: TextStyle(fontSize: 56),
                ),
             
              ],
            ),
          ),
        ),
      ),
    );
  }
}
