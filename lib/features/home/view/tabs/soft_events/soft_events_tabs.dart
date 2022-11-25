import 'package:event_keeper/features/home/controller/api_controller.dart';
import 'package:event_keeper/features/home/view/tabs/soft_events/error/soft_event_load_error_tab.dart';
import 'package:event_keeper/features/home/view/tabs/soft_events/error/soft_event_non_registered_tab.dart';
import 'package:event_keeper/shared/components/event_card.dart';
import 'package:event_keeper/shared/theme/app_color.dart';
import 'package:event_keeper/shared/core/app_dependencies.dart';
import 'package:event_keeper/shared/util/app_parses.dart';
import 'package:flutter/material.dart';

class SoftEventsTabs extends StatelessWidget {
  SoftEventsTabs({Key? key}) : super(key: key) {
    controller.getEventList();
  }

  final ApiController controller = getIt<ApiController>();

  @override
  Widget build(BuildContext context) {
    return _content();
  }

  Widget _content() {
    return Scaffold(
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : controller.onlineEventList.isEmpty
                  ? const SoftEventNonRegisteredTab()
                  : controller.isError
                      ? const SoftEventLoadErrorTab()
                      : _listViewBuilder();
        },
      ),
    );
  }

  Widget _listViewBuilder() {
    return ListView.builder(
      itemCount: controller.onlineEventList.length,
      itemBuilder: ((context, index) {
        final event = controller.onlineEventList[index];

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/details', arguments: event);
          },
          child: EventCard(
            weekDay: AppParses.weekDay(
              DateTime.parse(event.startTime),
            ),
            dayAndMonth: AppParses.dayMonth(
              DateTime.parse(event.startTime),
            ),
            iconButton: IconButton(
              onPressed: () {},
              icon:
                  // const Icon(
                  //   Icons.check,
                  //   color: AppColor.green,
                  //   size: 20,
                  // ),
                  const Icon(
                Icons.close,
                color: AppColor.red,
                size: 30,
              ),
            ),
            thumbnail: event.thumbnail,
            eventName: event.eventName,
            eventDescription: event.eventDescription,
            eventStartTime: AppParses.hour(
              DateTime.parse(event.startTime),
            ),
            eventEndTime: AppParses.hour(
              DateTime.parse(event.endTime),
            ),
            eventAddress: event.address?.street ?? '!!ERRO!!',
          ),
        );
      }),
    );
  }
}
