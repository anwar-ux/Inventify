// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dbmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataModelAdapter extends TypeAdapter<DataModel> {
  @override
  final int typeId = 0;

  @override
  DataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataModel(
      id: fields[0] as int?,
      uname: fields[1] as String?,
      email: fields[2] as String?,
      password: fields[3] as String?,
      image: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DataModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.uname)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DataModel2Adapter extends TypeAdapter<DataModel2> {
  @override
  final int typeId = 1;

  @override
  DataModel2 read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataModel2(
      id: fields[0] as int?,
      name: fields[1] as String?,
      image: fields[2] as String?,
      description: fields[3] as String?,
      categoryId: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, DataModel2 obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.categoryId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataModel2Adapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DataModel3Adapter extends TypeAdapter<DataModel3> {
  @override
  final int typeId = 2;

  @override
  DataModel3 read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataModel3(
      id: fields[0] as int?,
      name: fields[1] as String?,
      image: fields[2] as String?,
      description: fields[3] as String?,
      categoryId: fields[4] as int?,
      subcategoryId: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, DataModel3 obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.categoryId)
      ..writeByte(5)
      ..write(obj.subcategoryId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataModel3Adapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DataModel4Adapter extends TypeAdapter<DataModel4> {
  @override
  final int typeId = 3;

  @override
  DataModel4 read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataModel4(
      id: fields[0] as int?,
      purchaseprice: fields[5] as int?,
      sellingprice: fields[6] as int?,
      name: fields[1] as String?,
      image: fields[2] as String?,
      description: fields[3] as String?,
      brand: fields[7] as String?,
      subcategoryId: fields[4] as int?,
      stock: fields[8] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, DataModel4 obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.subcategoryId)
      ..writeByte(5)
      ..write(obj.purchaseprice)
      ..writeByte(6)
      ..write(obj.sellingprice)
      ..writeByte(7)
      ..write(obj.brand)
      ..writeByte(8)
      ..write(obj.stock);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataModel4Adapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BillAdapter extends TypeAdapter<Bill> {
  @override
  final int typeId = 4;

  @override
  Bill read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bill(
      phone: fields[4] as String?,
      sellingprice: (fields[3] as List).cast<String>(),
      totalprice: fields[6] as int?,
      productcategory: fields[8] as String?,
      productsubcategory: fields[9] as String?,
      productname: (fields[7] as List).cast<String>(),
      customername: fields[1] as String?,
      discountprice: fields[5] as int?,
      id: fields[0] as int?,
      date: fields[11] as String?,
      time: fields[12] as String?,
      subcategoryId: fields[2] as int?,
      count: (fields[10] as List).cast<String>(),
      totalproductsold: fields[13] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Bill obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.customername)
      ..writeByte(2)
      ..write(obj.subcategoryId)
      ..writeByte(3)
      ..write(obj.sellingprice)
      ..writeByte(4)
      ..write(obj.phone)
      ..writeByte(5)
      ..write(obj.discountprice)
      ..writeByte(6)
      ..write(obj.totalprice)
      ..writeByte(7)
      ..write(obj.productname)
      ..writeByte(8)
      ..write(obj.productcategory)
      ..writeByte(9)
      ..write(obj.productsubcategory)
      ..writeByte(10)
      ..write(obj.count)
      ..writeByte(11)
      ..write(obj.date)
      ..writeByte(12)
      ..write(obj.time)
      ..writeByte(13)
      ..write(obj.totalproductsold);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
