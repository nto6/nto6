#ifndef DANGKY_H
#define DANGKY_H
#include <iostream>
#include <string>
using namespace std;
class DangKy {
private:
    string maSV;
    string maLop;
public:
    DangKy(); 
    DangKy(string sv, string lop);
    string getMaSV();
    string getMaLop();
    void nhap();
    void xuat();
    friend istream& operator>>(istream& is, DangKy& dk);
    friend ostream& operator<<(ostream& os, DangKy dk);
};
#endif
