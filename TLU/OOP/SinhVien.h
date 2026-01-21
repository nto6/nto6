#ifndef SINHVIEN_H
#define SINHVIEN_H
#include <iostream>
#include <string>
using namespace std;
class SinhVien {
private:
    string maSV;
    string tenSV;
public:
    SinhVien();          
    SinhVien(string ma, string ten);
    string getMaSV();
    string getTenSV();
    void setMaSV(string ma);
    void setTenSV(string ten);
    void nhap();
    void xuat();
    friend istream& operator>>(istream& is, SinhVien& sv);
    friend ostream& operator<<(ostream& os, SinhVien sv);
};
#endif
