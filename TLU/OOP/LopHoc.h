#ifndef LOPHOC_H
#define LOPHOC_H
#include <iostream>
#include <string>
using namespace std;
class LopHoc {
private:
    string maLop;
    string tenLop;
public:
    LopHoc();
    LopHoc(string ma, string ten);
    string getMaLop();
    string getTenLop();
    void setMaLop(string ma);
    void setTenLop(string ten);
    void nhap();
    void xuat();
    friend istream& operator>>(istream& is, LopHoc& lh);
    friend ostream& operator<<(ostream& os, LopHoc lh);
};
#endif
