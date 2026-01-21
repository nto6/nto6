#include "LopHoc.h"
#include <iostream>
using namespace std;
LopHoc::LopHoc() {
    maLop = "";
    tenLop = "";
}
LopHoc::LopHoc(string ma, string ten) {
    maLop = ma;
    tenLop = ten;
}
string LopHoc::getMaLop() {
    return maLop;
}
string LopHoc::getTenLop() {
    return tenLop;
}
void LopHoc::setMaLop(string ma) {
    maLop = ma;
}
void LopHoc::setTenLop(string ten) {
    tenLop = ten;
}
void LopHoc::nhap() {
    cout << "Nhap ma lop: ";
    cin >> maLop;
    cin.ignore();
    cout << "Nhap ten lop: ";
    getline(cin, tenLop);
}
void LopHoc::xuat() {
    cout << maLop << " - " << tenLop << endl;
}
istream& operator>>(istream& is, LopHoc& lh) {
    is >> lh.maLop;
    is.ignore();
    getline(is, lh.tenLop);
    return is;
}
ostream& operator<<(ostream& os, LopHoc lh) {
    os << lh.maLop << endl;
    os << lh.tenLop << endl;
    return os;
}
