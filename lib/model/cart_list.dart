class CartListModel {
  String goodsId;
  String goodsName;
  int count;
  double price;
  String images;

  CartListModel(
      {this.goodsId, this.goodsName, this.count, this.price, this.images});

  static List<CartListModel> toModel(List list) {
    List<CartListModel> _arr = [];
    list.forEach((json) { 
        CartListModel co = CartListModel(
           goodsId: json['goodsId'],
           goodsName: json['goodsName'],
           count:json['count'],
           price:json['price'],
           images: json['images'] 
        );
        _arr.add(co);
    });
    return _arr;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goodsId'] = this.goodsId;
    data['goodsName'] = this.goodsName;
    data['count'] = this.count;
    data['price'] = this.price;
    data['images'] = this.images;
    return data;
  }
}