import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/common/widget_factory.dart';
import 'package:ku_animal_m/src/controller/app_controller.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';
import 'package:ku_animal_m/src/ui/product/product_history_model.dart';
import 'package:ku_animal_m/src/ui/product_in/product_in_controller.dart';
import 'package:ku_animal_m/src/ui/workmanage/work_data_model.dart';
import 'package:ku_animal_m/src/ui/workmanage/work_manager_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

// 입고 페이지
class PageWorkManager extends StatefulWidget {
  const PageWorkManager({super.key});

  @override
  State<PageWorkManager> createState() => _PageWorkManagerState();
}

class _PageWorkManagerState extends State<PageWorkManager> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  final TextEditingController _controllerSearch = TextEditingController();

  DateTime _focusedDay = DateTime.now();
  final Set<DateTime> _selectedDays = {};

  // 1. 상태 관리 변수
  TimeOfDay _startTime = TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = TimeOfDay(hour: 18, minute: 0);

  // Map<DateTime, Map<String, String>> _individualTimes = {
  //   DateTime(2025, 12, 23): {"start": "09:30", "end": "10:20"},
  //   DateTime(2025, 12, 24): {"start": "09:30", "end": "10:20"},
  //   DateTime(2025, 12, 26): {"start": "08:00", "end": "17:45"},
  // };

// 수정 가능 여부 플래그 저장 맵
  // Map<DateTime, bool> _editableFlags = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _controllerSearch.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildTotalSummary(),
          _buildTimeInputHeader(),
          // _buildTimePickerSection(),
          Divider(),
          // 2. 메인 캘린더 영역
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              // 1. 가용 높이에서 여유 공간(하단 버튼 등) 제외
              // 하단 액션바가 약 80~100픽셀 정도 차지하므로 그만큼 빼줍니다.
              double availableHeight = constraints.maxHeight - 100;

              // 2. 6줄로 나누어 한 칸당 높이 계산
              double dynamicRowHeight = availableHeight / 6;

              // 3. 너무 작거나 커지지 않게 제한 (방어 코드)
              if (dynamicRowHeight < 52) dynamicRowHeight = 52;
              if (dynamicRowHeight > 72) dynamicRowHeight = 72;

              return TableCalendar(
                locale: 'ko_KR',
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31), // 2026년 이후로도 이동 가능
                focusedDay: _focusedDay,
                rowHeight: dynamicRowHeight, // 최소 높이 방어선 구축
                daysOfWeekHeight: 30.0, // 요일 글자 잘림 방지
                // 헤더 스타일 (2025년 12월 형식)
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextFormatter: (date, locale) => DateFormat('yyyy년 MM월').format(date),
                  titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // 날짜 선택 로직
                selectedDayPredicate: (day) {
                  // .any를 사용하여 시간대에 상관없이 연/월/일이 같은지 체크합니다.
                  return _selectedDays.any((selectedDay) => isSameDay(selectedDay, day));
                },
                // 2. 길게 눌렀을 때 개별 수정 팝업 호출
                onDayLongPressed: (selectedDay, focusedDay) {
                  bool isEditable = WorkManagerController.to
                      .isEditableData(DateTime(selectedDay.year, selectedDay.month, selectedDay.day));

                  if (!isEditable) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("해당 날짜는 수정할 수 없습니다.")),
                    );
                    return;
                  }

                  _showEditSingleDayBottomSheet(selectedDay);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  // ⭐ 현재 보고 있는 달(focusedDay)과 선택한 날(selectedDay)의 월이 다르면 클릭 무시
                  if (selectedDay.month != focusedDay.month) {
                    return;
                  }

                  setState(() {
                    _focusedDay = focusedDay;

                    // 1. 이미 선택된 날짜가 있는지 '연/월/일'만 비교해서 찾습니다.
                    // isSameDay는 패키지에서 제공하는 함수입니다.
                    bool alreadySelected = _selectedDays.any((d) => isSameDay(d, selectedDay));

                    if (alreadySelected) {
                      // 2. 이미 있다면 리스트에서 제거 (isSameDay가 참인 객체를 제거)
                      _selectedDays.removeWhere((d) => isSameDay(d, selectedDay));
                    } else {
                      // 3. 없다면 추가 (시간값이 제거된 순수 날짜로 저장)
                      _selectedDays.add(DateTime(selectedDay.year, selectedDay.month, selectedDay.day));
                    }
                  });
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay; // 현재 보고 있는 달 업데이트
                    _selectedDays.clear(); // ⭐ 페이지 변경 시 선택된 날짜들 모두 초기화
                  });

                  _fetchFromServer(focusedDay); // 페이지 바뀔 때마다 해당 월 데이터 로딩
                },
                // 캘린더 디자인 빌더
                calendarBuilders: _buildCalendarBuilders(),
              );
            }),
          ),
          // 3. 하단 액션 영역
          _buildActionBottomBar(),
        ],
      ),
    );
  }

  // 상단 시간 선택기 UI
  Widget _buildTimeInputHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _timeColumn("출근", _startTime, true),
          Icon(Icons.arrow_forward, color: Colors.grey),
          _timeColumn("퇴근", _endTime, false),
        ],
      ),
    );
  }

  Widget _timeColumn(String label, TimeOfDay time, bool isStart) {
    return InkWell(
      onTap: () => _showCustomTimePicker(isStart), // 기본 showTimePicker 대신 호출
      child: Column(
        children: [
          Text(label, style: TextStyle(color: Colors.grey, fontSize: 12)),
          Text(
            "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // 캘린더 내부 커스텀 빌더
  CalendarBuilders _buildCalendarBuilders() {
    return CalendarBuilders(
      // 요일 색상 (일: 빨강, 토: 파랑)
      dowBuilder: (context, day) {
        if (day.weekday == DateTime.sunday) return Center(child: Text('일', style: TextStyle(color: Colors.red)));
        if (day.weekday == DateTime.saturday) return Center(child: Text('토', style: TextStyle(color: Colors.blue)));
        return null;
      },
      // 날짜 칸 내용 커스텀
      // defaultBuilder: (context, day, focusedDay) => _buildDayCell(day, Colors.black),
      // selectedBuilder: (context, day, focusedDay) => _buildDayCell(day, Colors.white, isSelected: true),
      // todayBuilder: (context, day, focusedDay) => _buildDayCell(day, Color(0xFF679E7D), isToday: true),
      // 2. 선택된 날짜의 스타일 (가장 중요)
      selectedBuilder: (context, day, focusedDay) {
        return _buildDayCell(day, Colors.red, isSelected: true);
      },
      // 오늘 날짜 스타일
      todayBuilder: (context, day, focusedDay) {
        // return _buildDayCell(day, Color(0xFF679E7D), isToday: true);
        return _buildDayCell(day, Color(0xFF294f2e), isToday: true);
      },
      // 일반 날짜 스타일
      defaultBuilder: (context, day, focusedDay) {
        return _buildDayCell(day, Colors.black);
      },
    );
  }

  Widget _buildDayCell(DateTime day, Color textColor, {bool isSelected = false, bool isToday = false}) {
    DateTime pureDate = DateTime(day.year, day.month, day.day);
    // final timeData = _individualTimes[pureDate];
    WorkData? timeData = WorkManagerController.to.getData(day);

    // 주말 색상 보정
    // Color dateColor = textColor;
    Color dateColor = isSelected ? Colors.white : textColor;
    if (!isSelected) {
      if (day.weekday == DateTime.sunday) dateColor = Colors.red;
      if (day.weekday == DateTime.saturday) dateColor = Colors.blue;
    }

    bool isEditable = WorkManagerController.to.isEditableData(pureDate);

    // ⭐ 총 시간 계산 로직 (uwts_work_time이 "08:00:00" 형태라고 가정하거나 직접 계산)
    String totalHours = "";
    if (timeData != null && timeData.start.isNotEmpty && timeData.end.isNotEmpty) {
      try {
        final s = timeData.start.split(':');
        final e = timeData.end.split(':');
        int diff = (int.parse(e[0]) * 60 + int.parse(e[1])) - (int.parse(s[0]) * 60 + int.parse(s[1]));
        if (diff > 0) {
          double hours = diff / 60;
          // 정수면 "8h", 소수점이 있으면 "8.5h" 형태로 표시
          totalHours = hours == hours.toInt() ? "${hours.toInt()}h" : "${hours.toStringAsFixed(1)}h";
        }
      } catch (_) {}
    }

    return Container(
      width: double.infinity,
      // height: double.infinity,
      margin: EdgeInsets.all(1),
      // decoration: BoxDecoration(
      //   color: isSelected ? Color(0xFF679E7D) : (isToday ? Colors.green.withValues(alpha: 0.1) : null),
      //   borderRadius: BorderRadius.circular(4),
      //   border: isToday ? Border.all(color: Color(0xFF679E7D)) : null,
      // ),
      decoration: BoxDecoration(
        // 2. 배경색: 선택됨(진녹색) / 오늘(연녹색) / 데이터 있음(연회색) / 기본(투명)
        color: !isEditable
            ? Colors.grey[200]
            : isSelected
                ? const Color(0xFF294f2e)
                : (isToday ? const Color(0xFF679E7D).withValues(alpha: 0.1) : Colors.transparent),
        borderRadius: BorderRadius.circular(6),
        // 3. 보더 설정: 데이터가 있거나 선택된 경우 보더를 주어 독립된 칸으로 보이게 함
        border: isSelected
            ? Border.all(color: const Color(0xFF294f2e))
            : (timeData != null
                ? Border.all(color: Colors.grey[300]!, width: 0.8) // 데이터 있는 날 보더
                : Border.all(color: Colors.grey[100]!, width: 0.5)), // 일반 날짜 아주 연한 보더
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (totalHours.isNotEmpty)
            Positioned(
              left: 3,
              top: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withValues(alpha: 0.2) : Colors.green[50],
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  totalHours,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.green[800],
                  ),
                ),
              ),
            ),

          // 우측 상단: 잠금 아이콘
          if (!isEditable) const Positioned(right: 3, top: 3, child: Icon(Icons.lock, size: 10, color: Colors.grey)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${day.day}",
                  style: TextStyle(
                      fontSize: 12, color: dateColor, fontWeight: isSelected || isToday ? FontWeight.bold : null)),
              // Spacer(),
              SizedBox(height: 2),
              // if (timeData != null) ...[
              //   _timeLabel(timeData['start']!, isSelected ? Colors.white : Colors.orange),
              //   SizedBox(height: 1),
              //   _timeLabel(timeData['end']!, isSelected ? Colors.white : Colors.blueGrey),
              // ],
              // 시간이 있든 없든 공간을 차지하게 하거나, 있을 때만 중앙 배치
              if (timeData != null) ...[
                _timeLabel(timeData.start, isSelected ? Colors.white : Colors.orange),
                const SizedBox(height: 1),
                _timeLabel(timeData.end, isSelected ? Colors.white : Colors.blueGrey),
              ] else
                // ⭐ 시간이 없는 날도 일정한 높이를 유지하고 싶다면 투명한 박스를 넣습니다.
                const SizedBox(height: 18),
              SizedBox(height: 1),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timeLabel(String time, Color color) {
    return Text(
      time,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 9,
        color: color,
        fontWeight: FontWeight.bold,
        height: 1.1, // 줄 간격 조절
      ),
    );
  }

  // 하단 버튼 바 (선택 해제 및 일괄 적용)
  Widget _buildActionBottomBar() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          // 1. 전체 선택 버튼
          TextButton(
            onPressed: _handleSelectAll, // 아래에서 정의할 함수
            child: const Text("전체 선택", style: TextStyle(color: Color(0xFF679E7D))),
          ),
          TextButton(
            onPressed: () => setState(() => _selectedDays.clear()),
            child: Text("선택 해제", style: TextStyle(color: Colors.grey)),
          ),
          if (_selectedDays.isNotEmpty)
            IconButton(
              onPressed: _handleBatchDelete, // 일괄 삭제 로직 호출
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              tooltip: "데이터 삭제",
            ),
          SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF679E7D),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: _selectedDays.isEmpty ? null : _handleBatchApply,
              child: Text("${_selectedDays.length}일 일괄 적용하기", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSelectAll() {
    // 1. 현재 화면에 보이는 달의 첫 날과 마지막 날 계산
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);

    setState(() {
      _selectedDays.clear(); // 기존 선택 초기화 (중복 방지)

      for (int i = 0; i < lastDay.day; i++) {
        DateTime day = firstDay.add(Duration(days: i));
        DateTime pureDate = DateTime(day.year, day.month, day.day);

        // 2. 서버에서 내려준 '수정 가능 플래그' 확인 (없으면 기본값 true)
        bool isEditable = WorkManagerController.to.isEditableData(pureDate);

        if (isEditable) {
          _selectedDays.add(pureDate);
        }
      }
    });

    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("이번 달에는 선택 가능한 날짜가 없습니다.")),
      );
    }
  }

  void _handleBatchDelete() async {
    // 1. 먼저 물어봅니다.
    bool confirm = await _showDeleteConfirmDialog("선택한 ${_selectedDays.length}일의 근무 기록을 모두 삭제하시겠습니까?");

    // 2. 사용자가 '삭제'를 눌렀을 때만 실행
    if (confirm) {
      AppController.to.setLoading(true);

      bool success = await WorkManagerController.to.deleteAndRefreshBatch(
        selectedDays: _selectedDays,
        year: _focusedDay.year,
        month: _focusedDay.month,
      );

      AppController.to.setLoading(false);

      if (success) {
        // 1. 성공 시에만 선택된 날짜들을 지우고 UI 리빌드
        setState(() {
          _selectedDays.clear();
        });
        Get.snackbar("완료", "선택한 기록이 삭제되었습니다.");
      } else {
        // 2. 실패 시에는 알림만 전달
        Get.snackbar("실패", "삭제에 실패했습니다. 다시 시도해 주세요.", backgroundColor: Colors.redAccent.withOpacity(0.1));
      }
    }
  }

  Future<bool> _showDeleteConfirmDialog(String message) async {
    return await Get.dialog<bool>(
          AlertDialog(
            backgroundColor: Colors.white, // 배경을 순백색으로 강제
            surfaceTintColor: Colors.white, // Material3 특유의 붉은 틴트 제거
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // 모서리 곡률 통일
            ),
            titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 10),
            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            title: const Text(
              "기록 삭제",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            content: Text(
              message,
              style: const TextStyle(fontSize: 15, color: Colors.black54, height: 1.4),
            ),
            actionsPadding: const EdgeInsets.fromLTRB(0, 10, 15, 15),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text("취소", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              ),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent, // 삭제 버튼은 경고의 의미로 빨간색 계열 사용
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text("삭제"),
              ),
            ],
          ),
        ) ??
        false;
  }

  // 일괄 적용 로직 및 덮어쓰기 알림
  void _handleBatchApply() async {
    // 1. 덮어쓰기 체크
    // bool hasExisting = _selectedDays.any((day) => _individualTimes.containsKey(day));
    bool hasExisting = _selectedDays.any((day) {
      WorkData? existingData = WorkManagerController.to.getData(day);
      return existingData != null;
    });

    if (hasExisting) {
      bool? confirm = await Get.dialog<bool>(
        AlertDialog(
          backgroundColor: Colors.white, // 배경을 순백색으로 강제
          surfaceTintColor: Colors.white, // Material3의 붉은 틴트 제거
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // 모서리 라운드 조절
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 10),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          title: const Text(
            "덮어쓰기 확인",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          content: const Text(
            "선택한 날짜 중 이미 기록이 있는 날짜가 있습니다.\n모두 새로 설정한 시간으로 변경할까요?",
            style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.4),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(0, 10, 15, 15),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text("취소", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF679E7D), // 수정 완료 버튼과 통일감 있는 색상
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text("덮어쓰기"),
            ),
          ],
        ),
      );

      if (confirm != true) return; // 취소 시 중단
    }

    AppController.to.setLoading(true);

    // 2. 데이터 저장
    // setState(() {
    String startStr = "${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}";
    String endStr = "${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}";

    // 1. Controller 호출하여 결과 모델 받기
    final result = await WorkManagerController.to.saveAndRefreshBatch(
      selectedDays: _selectedDays,
      startStr: startStr,
      endStr: endStr,
      year: _focusedDay.year,
      month: _focusedDay.month,
    );

    AppController.to.setLoading(false);

    if (result != null && result.result == "SUCCESS") {
      // 2. 실패 건수(fail)가 있는지 확인
      int failCount = result.fail ?? 0;

      if (failCount == 0) {
        // 케이스 A: 모두 성공
        setState(() => _selectedDays.clear());
        Get.snackbar("저장 완료", "모든 기록이 성공적으로 저장되었습니다.");
      } else {
        // 케이스 B: 부분 실패 (성공도 있고 실패도 있음)
        setState(() => _selectedDays.clear()); // 성공한 것들이 있으니 일단 클리어하거나, 실패한 날짜만 남겨둘 수 있음

        // 실패 내역 요약 정보 생성
        String failDetails =
            result.details!.where((d) => d.result == "FAIL").map((d) => "- ${d.date}: ${d.msg}").join("\n");

        Get.dialog(
          AlertDialog(
            title: Text("일부 저장 실패 ($failCount건)"),
            content: Text("성공: ${result.success}건\n실패: $failCount건\n\n[실패 사유]\n$failDetails"),
            actions: [
              TextButton(onPressed: () => Get.back(), child: Text("확인")),
            ],
          ),
        );
      }
    } else {
      // 케이스 C: 전체 통신 실패 혹은 서버 에러
      Get.snackbar("에러", result?.msg ?? "서버와 통신 중 오류가 발생했습니다.");
      setState(() => _selectedDays.clear());
    }
  }

  // 시간 선택기 UI
  Widget _buildTimePickerSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _timeTile("출근", _startTime, (t) => setState(() => _startTime = t)),
          Icon(Icons.arrow_forward),
          _timeTile("퇴근", _endTime, (t) => setState(() => _endTime = t)),
        ],
      ),
    );
  }

  Widget _timeTile(String label, TimeOfDay time, Function(TimeOfDay) onSelect) {
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(context: context, initialTime: time);
        if (picked != null) onSelect(picked);
      },
      child: Column(
        children: [
          Text(label, style: TextStyle(color: Colors.grey)),
          Text(time.format(context), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _applyBatchData() {
    // 여기서 API 호출 또는 로컬 DB 저장을 수행합니다.
    print("적용 날짜: $_selectedDays");
    print("설정 시간: ${_startTime.format(context)} ~ ${_endTime.format(context)}");

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("성공적으로 입력되었습니다.")));
  }

  void initData() async {
    AppController.to.setLoading(true);

    Future.delayed(const Duration(seconds: 3), () {
      AppController.to.setLoading(false);
    });
  }

  // 시간 표시용 작은 위젯
  Widget _timeBadge(String time, Color color) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 2),
      padding: EdgeInsets.symmetric(vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        time,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 8.5, // 아주 작은 폰트 사용
          fontWeight: FontWeight.w500,
          color: color,
          letterSpacing: -0.5, // 글자 간격 좁힘
        ),
      ),
    );
  }

  // Cupertino 스타일의 시간 선택기 예시 (10분 단위)
  void _showCustomTimePicker(bool isStart) {
    // 현재 설정된 시간을 초기값으로 세팅
    final now = DateTime.now();
    final initialTime = isStart ? _startTime : _endTime;
    final initialDateTime = DateTime(now.year, now.month, now.day, initialTime.hour, initialTime.minute);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          color: Colors.white,
          child: Column(
            children: [
              // 상단 확인/취소 바
              Container(
                color: Colors.grey[100],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: () => Navigator.pop(context), child: Text("취소")),
                    TextButton(onPressed: () => Navigator.pop(context), child: Text("확인")),
                  ],
                ),
              ),
              // 실제 피커
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true,
                  // minuteInterval: 10, // ⭐ 10분 단위로 조절 가능 (1, 5, 10, 15, 30 가능)
                  minuteInterval: 60,
                  initialDateTime: initialDateTime,
                  // ⭐ 퇴근 시간(isStart == false)일 때만 최소 시간을 출근 시간으로 제한
                  minimumDate:
                      isStart ? null : DateTime(now.year, now.month, now.day, _startTime.hour, _startTime.minute),
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      if (isStart) {
                        _startTime = TimeOfDay.fromDateTime(newDateTime);
                        // ⭐ 출근 시간이 퇴근 시간보다 늦어지면 퇴근 시간을 출근 시간으로 맞춤
                        if (_startTime.hour > _endTime.hour) {
                          _endTime = _startTime;
                        }
                      } else {
                        _endTime = TimeOfDay.fromDateTime(newDateTime);
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditSingleDayBottomSheet(DateTime day) async {
    // 1. 기존 데이터 불러오기 (없으면 현재 설정된 기본값 사용)
    DateTime pureDate = DateTime(day.year, day.month, day.day);
    // final existing = _individualTimes[pureDate];
    WorkData? existing = WorkManagerController.to.getData(pureDate);

    TimeOfDay tempStart = _startTime;
    TimeOfDay tempEnd = _endTime;

    if (existing != null) {
      final s = existing.start.split(':');
      final e = existing.end.split(':');
      tempStart = TimeOfDay(hour: int.parse(s[0]), minute: int.parse(s[1]));
      tempEnd = TimeOfDay(hour: int.parse(e[0]), minute: int.parse(e[1]));
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 높이 조절 가능하게
      backgroundColor: Colors.transparent, // 배경 투명하게 (커스텀 디자인용)
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 상단 바 (핸들)
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
            ),

            Text(
              "${DateFormat('MM월 dd일 (E)', 'ko_KR').format(day)} 시간 수정",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 출퇴근 시간 선택 (간소화된 UI)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      bool success = await WorkManagerController.to.deleteAndRefreshBatch(
                        selectedDays: {pureDate},
                        year: _focusedDay.year,
                        month: _focusedDay.month,
                      );

                      Get.back();

                      AppController.to.setLoading(false);

                      if (success) {
                        // 1. 성공 시에만 선택된 날짜들을 지우고 UI 리빌드
                        setState(() {
                          _selectedDays.clear();
                        });
                        Get.snackbar("완료", "선택한 기록이 삭제되었습니다.");
                      } else {
                        // 2. 실패 시에는 알림만 전달
                        Get.snackbar("실패", "삭제에 실패했습니다. 다시 시도해 주세요.",
                            backgroundColor: Colors.redAccent.withValues(alpha: 0.1));
                      }

                      // 삭제일때는 삭제 api를 호출해야함
                      // setState(() {});
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text("삭제", style: TextStyle(color: Colors.red)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPickerColumn("출근", tempStart, (newDate) {
                    tempStart = TimeOfDay.fromDateTime(newDate);
                  }),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                Expanded(
                  child: _buildPickerColumn("퇴근", tempEnd, (newDate) {
                    tempEnd = TimeOfDay.fromDateTime(newDate);
                  }),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 작업 버튼
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
                    child: const Text("취소"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      AppController.to.setLoading(true);

                      final result = await WorkManagerController.to.saveAndRefreshBatch(
                        selectedDays: {pureDate},
                        startStr:
                            "${tempStart.hour.toString().padLeft(2, '0')}:${tempStart.minute.toString().padLeft(2, '0')}",
                        endStr:
                            "${tempEnd.hour.toString().padLeft(2, '0')}:${tempEnd.minute.toString().padLeft(2, '0')}",
                        year: _focusedDay.year,
                        month: _focusedDay.month,
                      );

                      Get.back();

                      AppController.to.setLoading(false);

                      if (result != null && result.result == "SUCCESS") {
                        // 2. 실패 건수(fail)가 있는지 확인
                        int failCount = result.fail ?? 0;

                        if (failCount == 0) {
                          // 케이스 A: 모두 성공
                          setState(() => _selectedDays.clear());
                          Get.snackbar("저장 완료", "모든 기록이 성공적으로 저장되었습니다.");
                        } else {
                          // 케이스 B: 부분 실패 (성공도 있고 실패도 있음)
                          setState(() => _selectedDays.clear()); // 성공한 것들이 있으니 일단 클리어하거나, 실패한 날짜만 남겨둘 수 있음

                          // 실패 내역 요약 정보 생성
                          String failDetails = result.details!
                              .where((d) => d.result == "FAIL")
                              .map((d) => "- ${d.date}: ${d.msg}")
                              .join("\n");

                          Get.dialog(
                            AlertDialog(
                              title: Text("일부 저장 실패 ($failCount건)"),
                              content: Text("성공: ${result.success}건\n실패: $failCount건\n\n[실패 사유]\n$failDetails"),
                              actions: [
                                TextButton(onPressed: () => Get.back(), child: Text("확인")),
                              ],
                            ),
                          );
                        }
                      } else {
                        // 케이스 C: 전체 통신 실패 혹은 서버 에러
                        Get.snackbar("에러", result?.msg ?? "서버와 통신 중 오류가 발생했습니다.");
                        setState(() => _selectedDays.clear());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF679E7D),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text("수정 완료", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 바텀시트 내부에서 사용할 작은 피커 위젯
  Widget _buildPickerColumn(String label, TimeOfDay initialTime, Function(DateTime) onChanged) {
    final now = DateTime.now();
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        SizedBox(
          height: 120,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            use24hFormat: true,
            // minuteInterval: 10,
            minuteInterval: 60,
            initialDateTime: DateTime(now.year, now.month, now.day, initialTime.hour, initialTime.minute),
            onDateTimeChanged: onChanged,
          ),
        ),
      ],
    );
  }

  _buildList() {
    int itemCount = ProductInController.to.getCount();

    return Expanded(
      child: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: () async {
          _controllerSearch.clear();
          await ProductInController.to.refreshData();
          setState(() {
            debugPrint("0000007777111111");
            debugPrint("0000000777722222");
            _refreshController.refreshCompleted();
            debugPrint("000000777733333");
          });
        },
        onLoading: () {
          _refreshController.loadComplete();
        },
        child: itemCount == 0
            ? WidgetFactory.emptyWidgetWithFunc(onTap: () => refreshData())
            : ListView.builder(
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  return _buildProductItem(index);
                },
              ),
      ),
    );
  }

  _buildProductItem(int index) {
    if (index >= ProductInController.to.getCount()) {
      return Container();
    }

    ProductHistoryModel data = ProductInController.to.getItem(index);
    // String amount = data.mst_content.isEmpty ? "-" : "(${data.mst_content})";

    // 출고타입 PK, BOX, EA
    String type = data.mi_unit.isEmpty ? "" : "(${data.mi_unit})";

    String person = data.msr_man.isEmpty ? "-" : data.msr_man;

    return GestureDetector(
      onTap: () {
        Utils.showDetailDlg(context, title: data.mi_name);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
        padding: const EdgeInsets.all(15),
        // height: 130,
        decoration: WidgetFactory.boxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.mi_name, style: tsInvenItemNameRequest.copyWith(color: ColorsEx.clrIn)),
                    // Text("${data.mi_manufacturer} / ${data.mi_type_name} / ${data.mi_class_name}",
                    //     style: tsInvenItemCompany),
                    // const Spacer(),
                    const SizedBox(height: 10),
                    // Text("안전재고 (${data.mi_safety_stock})", style: tsInvenItemCompany),
                    Text("입고처리  ${person}", style: tsInvenItemCompany),
                    Text("주요성분 (${data.mi_ingredients})", style: tsInvenItemCompany),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${"Enter quantity".tr} (${data.msr_qty})", style: tsProductItemBold),
                        // Container(
                        //     // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        //     width: 90,
                        //     height: 24,
                        //     alignment: Alignment.center,
                        //     decoration: BoxDecoration(
                        //       color: Colors.grey[200],
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     child: Text("${"unit".tr} ${type}", style: tsProductItemBold)),
                        Text("${"unit".tr} ${type}", style: tsProductItemBold),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Container(
            //     margin: EdgeInsets.only(top: 5),
            //     alignment: Alignment.topRight,
            //     child: Text("등록일 (${data.regDate})", style: tsInvenItemCompany.copyWith(color: Colors.black))),
          ],
        ),
      ),
    );
  }

  // void refreshData() {
  //   Utils.keyboardHide();

  //   if (_controllerSearch.text.isEmpty) {
  //     Utils.showToast("Please input product name".tr);
  //     return;
  //   }
  //   _controllerSearch.clear();

  //   AppController.to.setLoading(true);
  //   Future.delayed(Duration(seconds: 3)).then((value) {
  //     setState(() {
  //       AppController.to.setLoading(false);
  //     });
  //   });
  // }

  Future<void> refreshData() async {
    AppController.to.setLoading(true);

    _controllerSearch.clear();
    await ProductInController.to.refreshData().then((value) => setState(() {
          // _controllerSearch.clear();
          AppController.to.setLoading(false);
        }));
  }

  // _showDirectInputDialog(BuildContext context) async {
  //   bool result = await showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) {
  //         return SearchDialog();
  //       });

  //   if (result) {}

  //   return result;
  // }

  void searchData() {
    Utils.keyboardHide();

    if (_controllerSearch.text.isEmpty) {
      Utils.showToast("Please input product name".tr);
      return;
    }

    AppController.to.setLoading(true);

    ProductInController.to.refreshData(searchData: _controllerSearch.text).then((value) {
      setState(() {
        // _controllerSearch.clear();
        AppController.to.setLoading(false);
      });
    });
  }

  Future<void> _fetchFromServer(DateTime currentDate) async {
    AppController.to.setLoading(true);

    try {
      // API 호출 시뮬레이션
      // var data = await ApiService.getMonthData(month);
      await WorkManagerController.to.refreshData(year: currentDate.year, month: currentDate.month);
    } finally {
      setState(() {
        AppController.to.setLoading(false);
      });
    }
  }

  Widget _buildTotalSummary() {
    return Obx(() {
      // isLoading 상태일 때는 로딩 표시, 아닐 때는 시간 표시
      String timeText = WorkManagerController.to.isLoading.value ? "계산 중..." : WorkManagerController.to.totalWorkTime;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blueGrey[100]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.access_time_filled, color: Colors.blueGrey, size: 20),
                SizedBox(width: 8),
                Text(
                  "이달의 총 근무 시간",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            Text(
              timeText,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
      );
    });
  }
}
