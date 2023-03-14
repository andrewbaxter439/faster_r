#include <Rcpp.h>
using namespace Rcpp;


// [[Rcpp::export]]
DataFrame updateDf(const DataFrame& df) {

  NumericVector A = df["A"];
  NumericVector B = df["B"];
  NumericVector C = df["C"];
  NumericVector D = df["D"];
  NumericVector E = df["E"];
  NumericVector a = df["a"];
  NumericVector a2 = df["a"];
  NumericVector b = df["b"];
  NumericVector b2 = df["b2"];
  NumericVector c = df["c"];
  NumericVector c2 = df["c"];
  NumericVector d = df["d"];
  NumericVector e = df["e"];
  
  int n = A.size();
  
  double lookup_a = 0.1;
  double lookup_b = 0.2;
  double lookup_d = 0.4;
  double lookup_e = 0.5;
    
  for(int i = 1; i < n; i++) {
    a[i] = (A[i]*123 + b[i-1]) * (1-lookup_a);
    a2[i] = a[i] * 123;
    b[i] = a[i] + a2[i];
    b[i] = (B[i]*123 + b[i-1]) * (1-lookup_b);
    b2[i] = b[i] * 123;
    c[i] = c[i-1] + c2[i-1];
    c2[i] = c[i] * 123;
    d[i] = (C[i]*123 + D[i]*123 + c[i-1]) * (1-lookup_d);
    e[i] = (D[i]*123 + e[i-1]) * (1-lookup_e);
  };
  
  DataFrame out = DataFrame::create(
  _["A"] = A,
  _["B"] = B,
  _["C"] = C,
  _["D"] = D,
  _["E"] = E,
  _["a"] = a,
  _["a2"] = a,
  _["b"] = b,
  _["b2"] = b2,
  _["c"] = c,
  _["c2"] = c,
  _["d"] = d,
  _["e"] = e
  );
  
  return out;
}
