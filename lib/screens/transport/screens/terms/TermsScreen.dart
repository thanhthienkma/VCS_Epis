import 'package:flutter/material.dart';
import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/style/BaseStyle.dart';
import 'package:trans/screens/transport/widgets/TransportHeaderWidget.dart';

class TermsConstants {
  static const text1 =
      '''Vỡ, móp méo, rách nhãn hoặc sản phẩm bên trong biến dạng do thời tiết trong quá trình vận chuyển.
Hàng bị mất mát, hư hỏng
Do điều kiện thời tiết, và các sự kiện nằm ngoài sự kiểm soát hợp lý của Công ty như: chiến tranh, hỏa hoạn.

Nếu hàng bị kẹt thông quan dưới 8 tuần kể từ ngày hàng về đến sân bay Việt Nam.
Hàng khách tự mua online và bị mất hay hư hỏng trong quá trình vận chuyển đến kho của công ty tại Sydney.
Bị hư hỏng, hết hạn hoặc xuống cấp
Trong quá trình lưu kho, vì thông quan chậm hoặc người nhận không chịu ký nhận hàng hoặc không liên hệ được với người nhận hàng 03 lần.

Khách hàng khiếu nại hàng bị hư hỏng, vỡ, mất mát nhưng không có giấy tờ chứng minh
Ghi chú trên tờ phiếu giao nhận hàng và báo ngay cho hotline VCS ngay khi phát hiện hàng hỏng, vỡ, mất mát trước khi kí nhận hàng.

Khách gửi hồ sơ yêu cầu đền bù sau 05 ngày làm việc kể từ ngày công ty giao hàng cho người nhận tại Việt Nam.
Hàng cấm hoặc hàng công ty không nhận gửi
Nhưng khách hàng cố tình gửi sẽ bị tịch thu bởi công ty, hãng bay, hải quan hoặc các cơ quan chức năng khác.

Hàng gửi khách hàng cố tình không khai báo, công ty có quyền tịch thu và sẽ không đền bù cho khách hàng.
Trong một số trường hợp đặc biệt, khách hàng có thể nhận lại những món hàng đã cố tình không khai báo, nhưng sẽ phải nộp phạt số tiền tương đương 02 lần mức cước phí quốc tế cho cho mặt hàng này.

Hàng khách tự mua hàng rồi gửi đến kho Sydney và khi nhận hàng ở Việt Nam
Phát hiện bị thiếu sản phẩm hoặc không đúng sản phẩm đã đặt mua, nhưng trọng lượng kiện hàng vẫn đúng như trong hóa đơn nhận từ .

Trường hợp này khách cần liên lạc trực tiếp với người bán hàng để giải quyết.''';
  static const text2 = '''Hàng gửi bị mất trong quá trình vận chuyển
(Chính sách đền bù 100% tiền hàng + 50% tiền phí ship hàng, giá trị đền bù tối đa AUD \$300 mỗi mã hàng)

Hàng gửi bị kẹt thông quan quá 8 tuần kể từ ngày hàng về đến sân bay
(đền bù 100% tiền hàng + 50% tiền phí ship hàng, giá trị đền bù tối đa AUD \$300 mỗi mã hàng)

Hàng của khách VIP hoặc khách hàng sử dụng dịch vụ mua hàng hộ của công ty
Bị ướt, hư hỏng nặng trong quá trình vận chuyển. Công ty sẽ đền bù khách hàng theo công thức: AUD \$20 * Tổng trọng lượng hàng bị hỏng tính theo kg.

Công ty sẽ có chính sách bồi thường số tiền AUD \$20/kg
Khi xảy ra trường hợp (a) hoặc (b) nếu quý khách: không cung cấp được hóa đơn mua hàng cho những mặt hàng bị mất.''';

  static const text3 = '''Bước 1:
QUÝ KHÁCH HÀNG VUI LÒNG GỬI EMAIL ĐẾN SUPPORT@EPIS.VN.
Bước 2:
THỜI GIAN GIẢI QUYẾT ĐỀN BÙ TỐI ĐA LÀ 10 NGÀY LÀM VIỆC KỂ TỪ NGÀY CÔNG TY NHẬN ĐẦY ĐỦ HỒ SƠ YÊU CẦU ĐỀN BÙ
(không kể chủ nhật , ngày lễ tết theo quy định pháp luật, tối đa 05 ngày làm việc kể từ ngày công ty giao hàng) của khách hàng.

Bước 3:
SỐ TIỀN ĐỀN BÙ CUỐI CÙNG CÔNG TY SẼ CHUYỂN VÀO TÀI KHOẢN CHỈ ĐỊNH CỦA KHÁCH HÀNG SAU 1-4 NGÀY LÀM VIỆC TÍNH TỪ KHI HAI BÊN THỐNG NHẤT PHƯƠNG ÁN ĐỀN BÙ
( không kể chủ nhật , thời gian nghỉ lễ, tết theo quy định bên Úc).

QUÝ KHÁCH VUI LÒNG GIỮ LẠI HÓA ĐƠN MUA HÀNG ĐỂ CÓ CƠ SỞ ĐỀN BÙ NẾU CÓ THIỆT HẠI VỀ HÀNG HÓA XẢY RA KHI QUÝ KHÁCH SỬ DỤNG DỊCH VỤ CỦA CÔNG TY.
Mọi thắc mắc liên quan đến việc bồi thường quý khách vui lòng email đến support@epis.vn
''';
}

class TermsScreen extends BaseScreen {
  @override
  Widget onInitBody(BuildContext context) {
    return Column(
      children: <Widget>[
        /// Transport header widget
        TransportHeaderWidget('Điều khoản và chính sách',
            textAlign: TextAlign.center, leftCallback: () {
          popScreen(context);
        }),

        Expanded(
          child: Container(
              padding: paddingAll20,
              child: ListView(
                children: <Widget>[
                  /// Create text widget
                  _createTextWidget(),
                ],
              )),
        ),
      ],
    );
  }

  Widget _createTextWidget() {
    return Column(
      children: <Widget>[
        Text('Chính Sách Bảo Hiểm Và Đền Bù',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

        ///
        _createShortText(
            'A. VCS sẽ KHÔNG ĐỀN BÙ khách hàng trong các trường hợp:'),

        ///
        _createLongText(TermsConstants.text1),

        ///
        _createShortText(
            'B. VCS sẽ có chính sách ĐỀN BÙ trong các trường hợp sau:'),

        ///
        _createLongText(TermsConstants.text2),

        ///
        _createShortText('C. Quy trình giải quyết chính sách đền bù:'),

        ///
        _createLongText(TermsConstants.text3),

        ///
        InkWell(
          onTap: () {
            /**
             * Handle open mail
             */
            handleOpenMail();
          },
          child: Container(
            child: Text(
              '''Thông tin liên hệ:
Email: support@vcs-vn.com.au | support@epis.vn
Fanpage: facebook.com/vcs.vietnamese''',
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          ),
        ),
      ],
    );
  }

  handleOpenMail() {}

  Widget _createShortText(text) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: Text(text,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)));
  }

  Widget _createLongText(String text) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10),
      child: Text(text),
    );
  }
}
