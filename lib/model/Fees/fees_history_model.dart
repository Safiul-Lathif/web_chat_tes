class FeesHistoryModel {
    int pfStuId;
    int activeStatus;
    String adjustedAmount;
    String paidAmount;
    int transId;
    String receiptNo;
    int pfPayMode;
    String paidDate;
    int totalPaid;
    String componentName;
    String subComponentName;
    String paymentMode;

    FeesHistoryModel({
        required this.pfStuId,
        required this.activeStatus,
        required this.adjustedAmount,
        required this.paidAmount,
        required this.transId,
        required this.receiptNo,
        required this.pfPayMode,
        required this.paidDate,
        required this.totalPaid,
        required this.componentName,
        required this.subComponentName,
        required this.paymentMode,
    });

    factory FeesHistoryModel.fromJson(Map<String, dynamic> json) => FeesHistoryModel(
        pfStuId: json["pf_stu_id"],
        activeStatus: json["active_status"],
        adjustedAmount: json["adjusted_amount"],
        paidAmount: json["paid_amount"],
        transId: json["trans_id"],
        receiptNo: json["receipt_no"],
        pfPayMode: json["pf_pay_mode"],
        paidDate: json["paid_date"],
        totalPaid: json["total_paid"],
        componentName: json["component_name"],
        subComponentName: json["sub_component_name"],
        paymentMode: json["payment_mode"],
    );

    Map<String, dynamic> toJson() => {
        "pf_stu_id": pfStuId,
        "active_status": activeStatus,
        "adjusted_amount": adjustedAmount,
        "paid_amount": paidAmount,
        "trans_id": transId,
        "receipt_no": receiptNo,
        "pf_pay_mode": pfPayMode,
        "paid_date": paidDate,
        "total_paid": totalPaid,
        "component_name": componentName,
        "sub_component_name": subComponentName,
        "payment_mode": paymentMode,
    };
}
