#include <iostream>

using namespace std;

int main() 
{
    long long n, factorial= 1, i;
    cin >> n;
    for (i = 1; i <= n; i++)
        factorial = factorial * i;
    if(factorial < 100) cout << factorial;
    else cout << 2;
}
