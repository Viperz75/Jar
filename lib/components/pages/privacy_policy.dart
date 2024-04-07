import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/theme_manager.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemeProvider>(context).themeModeType ==
              ThemeModeType.dark
          ? Colors.black // Set red background color for dark mode
          : const Color(0xfff5f7ec),
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Provider.of<ThemeProvider>(context).themeModeType ==
                ThemeModeType.dark
            ? Colors.black // Set red background color for dark mode
            : const Color(0xfff5f7ec),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Privacy Policy', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
              SizedBox(height: 5.0,),
              Text(
                  'This privacy policy applies to the Jar app (hereby referred to as "Application") for '
                      'mobile devices that was created by Niaz Mahmud Akash (hereby referred to as '
                      '"Service Provider") as an Open Source service. This service is '
                      'intended for use "AS IS".', textAlign: TextAlign.justify,),
              SizedBox(height: 8.0,),
              Text('What information does the Application obtain and how is it used?', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),

              SizedBox(height: 5.0,),
              Text('The Application does not obtain any information when you '
                  'download and use it. Registration is not required to use the Application.', textAlign: TextAlign.justify,),
              SizedBox(height: 8.0,),
              Text('Does the Application collect precise real time location information of the device?', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
              SizedBox(height: 5.0,),
              Text('This Application does not collect precise information about the location of your mobile device.', textAlign: TextAlign.justify,),
              SizedBox(height: 8.0,),
              Text('Do third parties see and/or have access to information obtained by the Application?', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
              SizedBox(height: 5.0,),
              Text('Since the Application does not collect any information, no data is shared with third parties.', textAlign: TextAlign.justify,),
              SizedBox(height: 8.0,),
              Text('What are my opt-out rights?', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
              SizedBox(height: 5.0,),
              Text('You can stop all collection of information by the Application easily by '
                  'uninstalling it. You may use the standard uninstall processes as '
                  'may be available as part of your mobile device or via the mobile '
                  'application marketplace or network.', textAlign: TextAlign.justify,),
              SizedBox(height: 8.0,),
              Text('Children', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
              SizedBox(height: 5.0,),
              Text("The Application is not used to knowingly solicit data from or market to children under the age of 13.The Service Provider does not knowingly collect personally identifiable information from children. The Service Provider encourages all children to never submit any personally identifiable information through the Application and/or Services. The Service Provider encourage parents and legal guardians to monitor their children's Internet usage and to help enforce this Policy by instructing their children never to provide personally identifiable information through the Application and/or Services without their permission. If you have reason to believe that a child has provided personally identifiable information to the Service Provider through the Application and/or Services, please contact the Service Provider (akash@alphaxb.com) so that they will be able to take the necessary actions. You must also be at least 16 years of age to consent to the processing of your personally identifiable information in your country (in some countries we may allow your parent or guardian to do so on your behalf).", textAlign: TextAlign.justify,),
              SizedBox(height: 8.0,),
              Text('Security', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
              SizedBox(height: 5.0,),
              Text('The Service Provider is concerned about safeguarding the confidentiality of your information. However, since the Application does not collect any information, there is no risk of your data being accessed by unauthorized individuals.', textAlign: TextAlign.justify,),
              SizedBox(height: 8.0,),
              Text('Changes', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
              SizedBox(height: 5.0,),
              Text('This Privacy Policy may be updated from time to time for any reason. The Service Provider will notify you of any changes to their Privacy Policy by updating this page with the new Privacy Policy. You are advised to consult this Privacy Policy regularly for any changes, as continued use is deemed approval of all changes.', textAlign: TextAlign.justify,),
              SizedBox(height: 8.0,),
              Text('This privacy policy is effective as of 2024-04-05', textAlign: TextAlign.justify,),
              SizedBox(height: 12.0,),
              Text('Your Consent', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
              SizedBox(height: 5.0,),
              Text('By using the Application, you are consenting to the processing of your information as set forth in this Privacy Policy now and as amended by the Service Provider.', textAlign: TextAlign.justify,),
              SizedBox(height: 8.0,),
              Text('Contact Us', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
              SizedBox(height: 5.0,),
              Text('If you have any questions regarding privacy while using the Application, or have questions about the practices, please contact the Service Provider via email at akash@alphaxb.com.', textAlign: TextAlign.justify,),
              SizedBox(height: 15.0,),
            ],
          ),
        ),
      ),
    );
  }
}
