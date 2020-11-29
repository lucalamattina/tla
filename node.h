#ifndef NODE_H_
#define NODE_H_


typedef enum token {

  Tmain, Twhile, Tlparen, Trparen, Tlbrack, Trbrack, Tif, Tsemicolon, Tequal, Tor, Tand,
  Tnot, Tisequal, Tdiff, Tlthan, Tlethan, Tgthan, Tgethan, Tadd, Tsubstract, Tmultiply, Tdivide, Tmodule, 
  Tstring, Tint, Tprint, Ttrue, Tfalse, Tid, Tint_E, Tstring_E, Tnotleaf, Tboolean,
  Treadbuff, Tcomma, Tempty, Treturn, Tfreebuff

} token;

static char * tokens[100] = {
  "int main", "while", "( ", ")", "{\n", " }\n", "if", ";\n", "= ", "|| ", "&& ", "! ",
  "== ", "!= ", "< ", "<= ", "> ", ">= ", "+ ", "- ", "* ", "/ ", "% ",
  "char * ", "int ", "printf", "1 ", "0 ","","","", "not Leaf ", "int ",
  "", ", ", "", "return ", "return 0;"};


typedef struct node_t {
  token token;
  char  * value;
  struct node_t  * next;
  struct node_t  * prev;
  struct node_t  * parent;
  struct node_t  * children;
} node_t;



node_t * new_node_with_val(char* val, token token);

node_t * new_node(char * val);


void print_headers();

void print_tree(node_t * node);

#define node_attach(parent, node)  node_insert_before((node_t *)parent, NULL, (node_t *)node)

node_t * node_insert_before(node_t * parent, node_t * sibling, node_t * node);

#define node_is_root(node)  (! ((node_t *)(node))->parent && ! ((node_t *)(node))->next)

node_t * node_root(node_t * node);

node_t * node_find(node_t * node, void * data, int (* compare)(void * a, void * b));

node_t * node_n_child(node_t * node, int n);

int node_total(node_t  * root);

void  node_unlink(node_t * node);

void  node_destroy(node_t * root);

int number_of_children(node_t * node);


#endif
