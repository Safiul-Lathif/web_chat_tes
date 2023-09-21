// class FeesStructureModelModel {
//     int feeClsId;
//     int classConfigId;
//     int feeCompId;
//     int subCompId;
//     String amount;
//     String newAmount;
//     DateTime feeStartDate;
//     DateTime feeEndDate;
//     dynamic feeRemDays;
//     String distType;
//     dynamic feeCourse;
//     String feeStatus;
//     String showSubComp;
//     String onlineFee;
//     int batch;
//     String gender;
//     String componentName;

//     FeesStructureModelModel({
//         required this.feeClsId,
//         required this.classConfigId,
//         required this.feeCompId,
//         required this.subCompId,
//         required this.amount,
//         required this.newAmount,
//         required this.feeStartDate,
//         required this.feeEndDate,
//         this.feeRemDays,
//         required this.distType,
//         this.feeCourse,
//         required this.feeStatus,
//         required this.showSubComp,
//         required this.onlineFee,
//         required this.batch,
//         required this.gender,
//         required this.componentName,
//     });

//     factory FeesStructureModelModel.fromJson(Map<String, dynamic> json) => FeesStructureModelModel(
//         feeClsId: json["fee_cls_id"],
//         classConfigId: json["class_config_id"],
//         feeCompId: json["fee_comp_id"],
//         subCompId: json["sub_comp_id"],
//         amount: json["amount"],
//         newAmount: json["new_amount"],
//         feeStartDate: DateTime.parse(json["fee_start_date"]),
//         feeEndDate: DateTime.parse(json["fee_end_date"]),
//         feeRemDays: json["fee_rem_days"],
//         distType: json["dist_type"],
//         feeCourse: json["fee_course"],
//         feeStatus: json["fee_status"],
//         showSubComp: json["show_sub_comp"],
//         onlineFee: json["online_fee"],
//         batch: json["batch"],
//         gender: json["gender"],
//         componentName: json["component_name"],
//     );

//     Map<String, dynamic> toJson() => {
//         "fee_cls_id": feeClsId,
//         "class_config_id": classConfigId,
//         "fee_comp_id": feeCompId,
//         "sub_comp_id": subCompId,
//         "amount": amount,
//         "new_amount": newAmount,
//         "fee_start_date": "${feeStartDate.year.toString().padLeft(4, '0')}-${feeStartDate.month.toString().padLeft(2, '0')}-${feeStartDate.day.toString().padLeft(2, '0')}",
//         "fee_end_date": "${feeEndDate.year.toString().padLeft(4, '0')}-${feeEndDate.month.toString().padLeft(2, '0')}-${feeEndDate.day.toString().padLeft(2, '0')}",
//         "fee_rem_days": feeRemDays,
//         "dist_type": distType,
//         "fee_course": feeCourse,
//         "fee_status": feeStatus,
//         "show_sub_comp": showSubComp,
//         "online_fee": onlineFee,
//         "batch": batch,
//         "gender": gender,
//         "component_name": componentName,
//     };
// }
class FeesStructureModel {
    int totalAmount;
    List<Fee> fees;

    FeesStructureModel({
        required this.totalAmount,
        required this.fees,
    });

    factory FeesStructureModel.fromJson(Map<String, dynamic> json) => FeesStructureModel(
        totalAmount: json["total_amount"],
        fees: List<Fee>.from(json["fees"].map((x) => Fee.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total_amount": totalAmount,
        "fees": List<dynamic>.from(fees.map((x) => x.toJson())),
    };
}

class Fee {
    int feeStuId;
    int feeCompId;
    int stuId;
    int subCompId;
    String amount;
    DateTime feeEndDate;
    String componentName;
    String subComponentName;
    dynamic overdueDays;

    Fee({
        required this.feeStuId,
        required this.feeCompId,
        required this.stuId,
        required this.subCompId,
        required this.amount,
        required this.feeEndDate,
        required this.componentName,
        required this.subComponentName,
        this.overdueDays,
    });

    factory Fee.fromJson(Map<String, dynamic> json) => Fee(
        feeStuId: json["fee_stu_id"],
        feeCompId: json["fee_comp_id"],
        stuId: json["stu_id"],
        subCompId: json["sub_comp_id"],
        amount: json["amount"],
        feeEndDate: DateTime.parse(json["fee_end_date"]),
        componentName: json["component_name"],
        subComponentName: json["sub_component_name"],
        overdueDays: json["overdue_days"],
    );

    Map<String, dynamic> toJson() => {
        "fee_stu_id": feeStuId,
        "fee_comp_id": feeCompId,
        "stu_id": stuId,
        "sub_comp_id": subCompId,
        "amount": amount,
        "fee_end_date": "${feeEndDate.year.toString().padLeft(4, '0')}-${feeEndDate.month.toString().padLeft(2, '0')}-${feeEndDate.day.toString().padLeft(2, '0')}",
        "component_name": componentName,
        "sub_component_name": subComponentName,
        "overdue_days": overdueDays,
    };
}