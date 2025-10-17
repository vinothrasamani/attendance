import 'package:flutter/material.dart';

class NoticeScreen extends StatelessWidget {
  const NoticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Color clr = Colors.grey.withAlpha(30);
    final size = MediaQuery.of(context).size;
    final d = [
      {
        'title': 'Notice title1',
        'body':
            'It\'s an example body one to display example UI for testing. It may replced while API integration.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Notice'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0.5),
          child: Container(height: 0.5, color: Colors.grey),
        ),
        actions: [
          PopupMenuButton(
            padding: EdgeInsets.all(0),
            menuPadding: EdgeInsets.all(0),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 5),
                    Text('Refresh'),
                  ],
                ),
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.delete),
                    SizedBox(width: 5),
                    Text('Clear'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: clr,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  '📝 Available Notices for you!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 5),
              if (d.isEmpty)
                SizedBox(
                  height: size.height * 0.8,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.filter_list_off, size: 35),
                        SizedBox(height: 10),
                        Text('No Notice Available!')
                      ],
                    ),
                  ),
                ),
              for (var item in d)
                Container(
                  color: clr,
                  margin: EdgeInsets.only(bottom: 5),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] ?? 'Notice Title!',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(item['body'] ?? 'Notice content is here..'),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
