import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../widgets/text_themes/app_header_text.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 64),
        child: Column(
          children: [
            AppHeaderText(
              icon: Iconsax.timer_1,
              text: 'My Account',
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Theme.of(context).disabledColor.withOpacity(0.1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 35,
                    child: Text('S'),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Sumit Kumar Pradhan',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                ],
              ),
            ),
            AccountTileSwitch(),
          ],
        ),
      ),
    );
  }
}

class AccountTileSwitch extends StatelessWidget {
  const AccountTileSwitch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Text('Intelligent cache'),
                const Spacer(),
                CupertinoSwitch(
                  value: true,
                  onChanged: (v) {},
                )
              ],
            ),
          ),
          Text(
            'Based on your music playing item, it will cache most played items',
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
