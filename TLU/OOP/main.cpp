#include <iostream>
#include <vector>
#include "SinhVien.h"
#include "LopHoc.h"
#include "DangKy.h"
#include "XuLyFile.h"
using namespace std;

void menu(){
    cout << "\n===== MENU =====\n";
    cout << "1. Them sinh vien\n";
    cout << "2. Sua sinh vien\n";
    cout << "3. Xoa sinh vien\n";
    cout << "4. Them lop hoc\n";
    cout << "5. Sua lop hoc\n";
    cout << "6. Xoa lop hoc\n";
    cout << "7. Dang ky hoc\n";
    cout << "8. Huy dang ky\n";
    cout << "9. Liet ke sinh vien\n";
    cout << "10. Liet ke lop hoc\n";
    cout << "11. Liet ke dang ky\n";
    cout << "12. Liet ke lop va sinh vien\n";
    cout << "13. Thoat\n";
    cout << "Chon: ";
}

int timSV(vector<SinhVien> ds, string ma) {
    for (int i = 0; i < ds.size(); i++)
        if (ds[i].getMaSV() == ma)
            return i;
    return -1;
}
int timLop(vector<LopHoc> ds, string ma) {
    for (int i = 0; i < ds.size(); i++)
        if (ds[i].getMaLop() == ma)
            return i;
    return -1;
}
int main() {
    vector<SinhVien> dsSV = docFile<SinhVien>("sinhvien.dat");
    vector<LopHoc> dsLop = docFile<LopHoc>("lophoc.dat");
    vector<DangKy> dsDK = docFile<DangKy>("dangky.dat");
    int chon;
    do {
        menu();
        cin >> chon;
        if (chon >= 13) {
            return 0;
        }
        if (chon == 1) {
            SinhVien sv;
            sv.nhap();
            dsSV.push_back(sv);
            ghiFile("sinhvien.dat", dsSV);
        }
        else if (chon == 2) {
            string ma;
            cout << "Nhap ma SV: ";
            cin >> ma;
            int i = timSV(dsSV, ma);
            if (i == -1) cout << "Khong tim thay!\n";
            else {
                dsSV[i].nhap();
                ghiFile("sinhvien.dat", dsSV);
            }
        }
        else if (chon == 3) {
            string ma;
            cout << "Nhap ma SV: ";
            cin >> ma;
            int i = timSV(dsSV, ma);
            if (i == -1) cout << "Khong tim thay!\n";
            else {
                dsSV.erase(dsSV.begin() + i);
                ghiFile("sinhvien.dat", dsSV);
            }
        }
        else if (chon == 4) {
            LopHoc lh;
            lh.nhap();
            dsLop.push_back(lh);
            ghiFile("lophoc.dat", dsLop);
        }
        else if (chon == 5) {
            string ma;
            cout << "Nhap ma lop: ";
            cin >> ma;
            int i = timLop(dsLop, ma);
            if (i == -1) cout << "Khong tim thay!\n";
            else {
                dsLop[i].nhap();
                ghiFile("lophoc.dat", dsLop);
            }
        }
        else if (chon == 6) {
            string ma;
            cout << "Nhap ma lop: ";
            cin >> ma;
            int i = timLop(dsLop, ma);
            if (i == -1) cout << "Khong tim thay!\n";
            else {
                dsLop.erase(dsLop.begin() + i);
                ghiFile("lophoc.dat", dsLop);
            }
        }
        else if (chon == 7) {
            DangKy dk;
            dk.nhap();
            dsDK.push_back(dk);
            ghiFile("dangky.dat", dsDK);
        }
        else if (chon == 8) {
            string sv, lop;
            cout << "Ma SV: "; cin >> sv;
            cout << "Ma lop: "; cin >> lop;
            for (int i = 0; i < dsDK.size(); i++)
                if (dsDK[i].getMaSV() == sv &&
                    dsDK[i].getMaLop() == lop) {
                    dsDK.erase(dsDK.begin() + i);
                    ghiFile("dangky.dat", dsDK);
                    break;
                }
        }
        else if (chon == 9)
            for (int i = 0; i < dsSV.size(); i++)
                dsSV[i].xuat();
        else if (chon == 10)
            for (int i = 0; i < dsLop.size(); i++)
                dsLop[i].xuat();

        else if (chon == 11)
            for (int i = 0; i < dsDK.size(); i++)
                dsDK[i].xuat();
        else if (chon == 12) {
            for (int i = 0; i < dsLop.size(); i++) {
                dsLop[i].xuat();
                for (int j = 0; j < dsDK.size(); j++)
                    if (dsDK[j].getMaLop() == dsLop[i].getMaLop())
                        for (int k = 0; k < dsSV.size(); k++)
                            if (dsSV[k].getMaSV() == dsDK[j].getMaSV()) {
                                cout << "   ";
                                dsSV[k].xuat();
                            }
            }
        }
        

    } while (true);

    return 0;
}
