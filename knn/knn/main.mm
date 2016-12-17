//
//  main.m
//  knn
//
//  Created by Samuco on 15/12/16.
//  Copyright © 2016 Samuco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#include <string>

#include <iostream>
#include <set>
#include <vector>
#include <map>
#include <cmath>

#include <time.h>
#include <iostream>
#include <fstream>
#include <sstream>
#include <thread>
#include <mutex>
#include <sys/stat.h>
#include <unistd.h>
#include <random>
#include <unordered_map>

using namespace std;

const int cc = 10;
const int cr = 79726;
typedef struct {
    string name;
    float c[cc];
} row;

row *readCSV(string almlm) {
    row *rows = (row *)malloc(sizeof(row) * cr);
    
    ifstream cvfile(almlm);
    
    string head;
    getline(cvfile, head);
    
    int r = 0;
    string line;
    while (getline(cvfile, line)) {
        int i = 0;
        size_t pos = 0;
        while ((pos = line.find(",")) != string::npos) {
            string qq = line.substr(0, pos);
            if (i > 0) {
                rows[r].c[i-1] = std::stod(qq);
            } else {
                rows[r].name = qq;
            }
            
            line.erase(0, pos + 1);
            i++;
        }
        string qq = line.substr(0, pos);
        if (i > 0) {
            rows[r].c[i-1] = std::stod(qq);
        } else {
            rows[r].name = qq;
        }
        r++;
    }
    cvfile.close();
    return rows;
}

float mC(row r) {
    float mm = 0;
    for (int i = 0; i < cc; i++) {
        if (i == 0 || r.c[i] > mm) {
            mm = r.c[i];
        }
    }
    return mm;
}
float mCi(row r) {
    float mm = 0;
    int mc = 0;
    for (int i = 0; i < cc; i++) {
        if (i == 0 || r.c[i] > mm) {
            mm = r.c[i];
            mc = i;
        }
    }
    return mc;
}

void writeCSV(string almlm, row *csv) {
    ofstream out;
    out.open(almlm, ios::out | ios::trunc);
    out << "img,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9" << endl;
    for (int i = 0; i < cr; i++) {
        out << csv[i].name;
        for (int c = 0; c < cc; c++) {
            out << "," << csv[i].c[c];
        }
        out << endl;
    }
    out.close();
}

int main(int argc, const char * argv[]) {
    string ensemble = "/Users/samuco/Dropbox/Users/Samuco/[3] University/[1] Stanford/[1] Documents/[5] Autumn/CS229/CS229/resnet/ensemble/";
    
    row *almlm = readCSV(ensemble + "allm.csv");
    
    row *gnet1 = readCSV(ensemble + "googlenet500.csv");
    row *gnet2 = readCSV(ensemble + "googlenet2.csv");
    row *gnet3 = readCSV(ensemble + "google3.csv");
    
    row *vgg1 = readCSV(ensemble + "vgg0.42");
    row *vgg2 = readCSV(ensemble + "submission_vgg3.csv");     //0.44882
    row *vgg3 = readCSV(ensemble + "submission_vgg3-2.csv");   //0.63661
    row *vgg4 = readCSV(ensemble + "submission_vgg2.csv");     //0.48507
    row *vgg5 = readCSV(ensemble + "submission_vgg_new2.csv"); //0.41757
    row *vgg6 = readCSV(ensemble + "submission_vgg_new.csv");  //0.63571
    
    
    
    row *vgg7 = readCSV(ensemble + "vgg0.45.csv");  //0.63571
    row *vgg8 = readCSV(ensemble + "vgg0.48.csv");  //0.63571
    row *vgg9 = readCSV(ensemble + "vgg0.49.csv");  //0.63571
    row *vgg10 = readCSV(ensemble + "vgg0.50.csv");  //0.63571
    row *vgg11 = readCSV(ensemble + "vgg0.55.csv");  //0.63571
    row *vgg12 = readCSV(ensemble + "vgg0.58.csv");  //0.63571
    row *vgg13 = readCSV(ensemble + "vgg0.440.csv");  //0.63571
    row *vgg14 = readCSV(ensemble + "vgg0.445.csv");  //0.63571
    row *vgg15 = readCSV(ensemble + "vgg0.42.csv");  //0.63571
    
    
    
    int combined = 11;
    row *combination[] = {vgg7, vgg8, vgg9, vgg10, vgg11, vgg12, vgg13, vgg14, vgg15, gnet2, gnet3};
    
    // Merge
    row *output = (row *)malloc(sizeof(row) * cr);
    int i;
    for (i = 0; i < cr; i++) {
        float mB = 0;
        for (int c = 0; c < combined; c++) {
            float w = mC(combination[c][i]);
            if (c == 0 || w > mB) {
                mB = w;
                output[i] = combination[c][i];
            }
        }
        
        // Take the mean
        for (int z = 0; z < cc; z++) {
            output[i].c[z] = 0;
            for (int c = 0; c < combined; c++) {
                output[i].c[z] += combination[c][i].c[z];
            }
            output[i].c[z] /= combined;
        }
        
        // Take the mean of 'agreed' classes
        for (int round = 0; round < 20; round++) {
            for (int z = 0; z < cc; z++) {
                int mci = mCi(output[i]);
                int agree = 0;
                output[i].c[z] = 0;
                for (int c = 0; c < combined; c++) {
                    if (mCi(combination[c][i]) == mci) {
                        output[i].c[z] += combination[c][i].c[z];
                        agree++;
                    }
                }
                if (agree == 0) { // Who knows!
                    output[i].c[z] = vgg15[i].c[z];
                } else {
                    output[i].c[z] /= agree;
                }
            }
        }
        
        
        // Which class is predicted?
        /*
        int pc = mCi(output[i]);
        if (pc == mCi(gnet3[i])) {
            for (int z = 0; z < cc; z++) {
                output[i].c[z] = (output[i].c[z] * combined + gnet3[i].c[z]) / (combined + 1);
            }
        }
        */
        
        
        
        // Redistribute probabilities
        /*
        for (int c = 0; c < cc; c++) {
            output[i].c[c] += 0.0000000001;
        }
        */
        
        /*
        float mi = mC(output[i]);
        int mic = mCi(output[i]);
        if (mi < 0.95) {
            for (int c = 0; c < cc; c++) {
                output[i].c[c] = 0.09;
                if (c == mic) {
                    output[i].c[c] += 0.1;
                }
            }
        } else {
            for (int c = 0; c < cc; c++) {
                output[i].c[c] = 0;
                if (c == mic) {
                    output[i].c[c] += 1;
                }
            }
        }
        */
    }
    writeCSV(ensemble + "merge4.csv", output);
    
    return 0;
}
