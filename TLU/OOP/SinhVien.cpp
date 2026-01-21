#include "SinhVien.h"
#include <iostream>
using namespace std;
SinhVien::SinhVien() {
    maSV = "";
    tenSV = "";
}
SinhVien::SinhVien(string ma, string ten) {
    maSV = ma;
    tenSV = ten;
}
string SinhVien::getMaSV() {
    return maSV;
}
string SinhVien::getTenSV() {
    return tenSV;
}
void SinhVien::setMaSV(string ma) {
    maSV = ma;
}
void SinhVien::setTenSV(string ten) {
    tenSV = ten;
}
void SinhVien::nhap() {
    cout << "Nhap ma SV: ";
    cin >> maSV;
    cin.ignore();
    cout << "Nhap ten SV: ";
    getline(cin, tenSV);
}
void SinhVien::xuat() {
    cout << maSV << " - " << tenSV << endl;
}
istream& operator>>(istream& is, SinhVien& sv) {
    is >> sv.maSV;
    is.ignore();
    getline(is, sv.tenSV);
    return is;
}
ostream& operator<<(ostream& os, SinhVien sv) {
    os << sv.maSV << endl;
    os << sv.tenSV << endl;
    return os;
}
