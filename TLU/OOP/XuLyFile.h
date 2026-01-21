#ifndef XULYFILE_H
#define XULYFILE_H
#include <fstream>
#include <vector>
using namespace std;

template <class T>
vector<T> docFile(const char* tenFile) {
    vector<T> ds;
    ifstream f(tenFile);
    if (!f.is_open()) return ds;

    while (!f.eof()) {
        T x;
        f >> x;
        if (f) ds.push_back(x);
    }
    f.close();
    return ds;
}

template <class T>
void ghiFile(const char* tenFile, vector<T> ds) {
    ofstream f(tenFile);
    for (int i = 0; i < ds.size(); i++) {
        f << ds[i];
    }
    f.close();
}

#endif
