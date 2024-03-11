import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:riverbank_pretotype_mobile/component/dropdown.dart';
import 'package:riverbank_pretotype_mobile/translate/service/translation_service.dart';

class TranslationPage extends StatefulWidget {
  const TranslationPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TranslationPageState();
  }
}

class _TranslationPageState extends State<TranslationPage> {
  String _original = 'English';
  String _target = 'Korean';
  final TranslationService _service = TranslationService();
  String _originalText = '';
  final TextEditingController _originalTextController = TextEditingController();
  final TextEditingController _targetTextController = TextEditingController();

  Future<void> _translate() async {
    String translatedText = await _service.translate('korean', _originalTextController.text);
    _targetTextController.text = translatedText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Translation', style: TextStyle(fontWeight: FontWeight.bold),)
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          height: 600,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xff3629B7).withOpacity(0.07),
                    offset: const Offset(0, 4),
                    blurRadius: 30
                )
              ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: 120,
                  child: Dropdown<String>(
                    list: const ['English', 'Chinese', 'Japanese'],
                    onChanged: (String? value) {
                      setState(() {
                        _original = value!;
                      });
                    },
                    value: _original,
                  )
              ),
              Stack(
                children: [
                  TextField(
                    maxLines: 5,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter the text',
                        hintStyle: TextStyle(fontSize: 28, color: Color(0xFFC5C5C5))
                    ),
                    controller: _originalTextController,
                  ),
                  Positioned(
                      top: 20,
                      right: 0,
                      child: SvgPicture.asset('asset/image/ic_mic.svg')
                  )
                ],
              ),
              Container(
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Divider(
                          color: Color(0xFFE9E9E9)
                      ),
                      Center(
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(360),
                                  color: Color(0xFFE9E9E9)
                              ),
                              padding: const EdgeInsets.all(10),
                              child: SvgPicture.asset('asset/image/ic_shuffle.svg', colorFilter: ColorFilter.mode(Color(0xFFB0A1D5), BlendMode.srcIn),)
                          )
                      )
                    ],
                  )
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 120,
                child: Dropdown<String>(
                  list: const ['Korean', 'English', 'Chinese', 'Japanese'],
                  onChanged: (String? value) {
                    setState(() {
                      _target = value!;
                    });
                  },
                  value: _target,
                ),
              ),
              TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                controller: _targetTextController,
              ),
              Container(
                margin: const EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  color: const Color(0xff3629B7),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: CupertinoButton(
                  onPressed: () async {
                    await _translate();
                  },
                  child: Container(
                    child: const Center(
                      child: Text('Translate', style: TextStyle(color: Colors.white, fontSize: 20))
                    )
                  ),
                ),
              )
            ],
          ),
        )
      )
    );
  }
}