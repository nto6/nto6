#include "DangKy.h"
#include <iostream>
using namespace std;
DangKy::DangKy() {
    maSV = "";
    maLop = "";
}
DangKy::DangKy(string sv, string lop) {
    maSV = sv;
    maLop = lop;
}
string DangKy::getMaSV() {
    return maSV;
}
string DangKy::getMaLop() {
    return maLop;
}
void DangKy::nhap() {
    cout << "Nhap ma SV: ";
    cin >> maSV;
    cout << "Nhap ma lop: ";
    cin >> maLop;
}
void DangKy::xuat() {
    cout << maSV << " dang ky lop " << maLop << endl;
}
istream& operator>>(istream& is, DangKy& dk) {
    is >> dk.maSV >> dk.maLop;
    return is;
}
ostream& operator<<(ostream& os, DangKy dk) {
    os << dk.maSV << " " << dk.maLop << endl;
    return os;
}
