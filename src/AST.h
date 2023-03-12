
#include <vector>

struct Node;

using namespace std;

Node* createNode(char* value, vector<Node*> children);
Node* createNode(char* value);
Node* createNode(char* lexeme, char* token);

int buildTree(FILE* dotfile, Node* node, int parentno, int co) ;
