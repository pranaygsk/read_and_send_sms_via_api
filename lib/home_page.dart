import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final Telephony query = Telephony.instance;
  List messages = [];

  @override
  void initState() {
    super.initState();
  }

  postData(List<dynamic> messages) async{
    try {
      var response = await http.post(
          Uri.parse('https://jsonplaceholder.typicode.com/posts'),
          body: {
            for(int i = 0; i < messages.length; i++){
              "id": "${messages[i].id}",
              "message-address": "${messages[i].address}",
            }
          });
      print(response.body);
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("SMS Inbox"),
          backgroundColor: Colors.pink,
        ),
        body: FutureBuilder(
          future: fetchSMS() ,
          builder: (context, snapshot)  {

            return ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.black,
                ),
                itemCount: messages.length,
                itemBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.markunread,
                        color: Colors.pink,
                      ),
                      title: Text(messages[index].address),
                      subtitle: Text(messages[index].body,maxLines:2,),
                    ),
                  );
                });
          },)
    );
  }

  fetchSMS() async {
    messages = await query.getInboxSms(columns: DEFAULT_SMS_COLUMNS ,filter: SmsFilter.where(SmsColumn.ADDRESS).like("%wakeft%"));
    postData(messages);
  }
}
