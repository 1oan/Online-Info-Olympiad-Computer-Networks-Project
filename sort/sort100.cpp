#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

void lexicographicallySortColumns(vector<vector<int>> &matrix) {
    int n = matrix.size();
    vector<pair<vector<int>, int>> columns;

    // Store columns along with their original indices
    for (int j = 0; j < n; ++j) {
        vector<int> column(n);
        for (int i = 0; i < n; ++i) {
            column[i] = matrix[i][j];
        }
        columns.push_back({column, j});
    }

    // Sort columns lexicographically
    sort(columns.begin(), columns.end());

    // Rearrange the matrix based on the sorted columns
    vector<vector<int>> sortedMatrix(n, vector<int>(n));
    for (int j = 0; j < n; ++j) {
        int originalIndex = columns[j].second;
        for (int i = 0; i < n; ++i) {
            sortedMatrix[i][j] = matrix[i][originalIndex];
        }
    }

    // Copy sorted matrix back to original matrix
    matrix = sortedMatrix;
}

int main() {
    int n;
    cin >> n;
    vector<vector<int>> matrix(n, vector<int>(n));
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            cin >> matrix[i][j];
        }
    }

    lexicographicallySortColumns(matrix);

    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            cout << matrix[i][j] << " ";
        }
        cout << endl;
    }

    return 0;
}
