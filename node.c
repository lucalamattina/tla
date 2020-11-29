/*
 * node.c
 *
 *  Created on: Mar 7, 2011
 *      Author: posixninja
 *
 * Copyright (c) 2011 Joshua Hill. All Rights Reserved.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "node.h"

node_t * new_node_with_val(char* val, token token){
	node_t * n = (node_t *)malloc(sizeof(node_t));
  
	if (n == NULL){
		return n;
	}
	n->token = token;
	n->value = val;
	n->next = NULL;
	n->prev = NULL;
	n->parent = NULL;
	n->children = NULL;
	return n;
}

node_t * new_node(char * val){
	node_t * new = new_node_with_val(val, Tnotleaf);
	return new;
}


node_t* node_insert_before(node_t *parent, node_t *sibling, node_t *node)
{
  if (! (parent && node) || (sibling && sibling->parent == parent))
    return NULL;
  node->parent = parent;
  if (sibling)
  {
    if (sibling->prev)
    {
      node->prev = sibling->prev;
      node->prev->next = node;
    }
    else
      node->parent->children = node;
    node->next = sibling;
    sibling->prev = node;
  }
  else
  {
    if (parent->children)
    {
      sibling = parent->children;
      while (sibling->next)
        sibling = sibling->next;
      node->prev = sibling;
      sibling->next = node;
    }
    else
      node->parent->children = node;
  }
  return node;
}

node_t* node_root(node_t *node)
{
  if (! node)
    return NULL;
  if (node->parent)
    return node_root(node->parent);
  return node;
}

node_t* node_find(node_t *node, void *data, int (*compare)(void *a, void *b))
{
  if (! node)
    return node;
  if (! compare(data, node->value))
    return node;
  if (node->next)
    return node_find(node->next, data, compare);
  if (node->children)
    return node_find(node->children, data, compare);
  return NULL;
}

node_t* node_n_child(node_t *node, int n)
{
  if (! node)
    return NULL;
  node = node->children;
  while (node && (n-- > 0))
    node = node->next;
  return node;
}

int node_total(node_t  *root)
{
  if (! root)
    return 0;
  int t;
  
  t = 1;
  if (root->children)
    t += node_total(root->children);
  if (root->next)
    t += node_total(root->next);
  return t;
}

void  node_unlink(node_t * node)
{
  if (! node)
    return;
  if (node->prev)
    node->prev->next = node->next;
  else if (node->parent)
    node->parent->children = node->next;
  if (node->next)
  {
    node->next->prev = node->prev;
    node->next = NULL;
  }
  node->prev = NULL;
  node->parent = NULL;
}

void  node_free(node_t *node)
{
  if (! node)
    return;
  if (node->children)
    node_free(node->children);
  if (node->next)
    node_free(node->next);
  free(node);
}

void  node_destroy(node_t *root)
{
  if (! root)
    return;
  if (! node_is_root(root))
    node_unlink(root);
  node_free(root);
}

int number_of_children(node_t * node){
  int ret = 0;
  node_t * aux = node->children;
  while(aux != NULL){
    aux = aux->next;
    ret++;
  }
  return ret;
}

void print_tree(node_t * node){
	if(node == NULL){
		printf("ERROR 1\n");
		return;
	}
	if(node->token != Tnotleaf){
		if(node->token != Tint_E && node->token != Tstring_E && node->token != Tid) {
     	 		node->value = tokens[node->token];
    		}
		if(node->value == NULL){
      			printf( "ERROR 2\n");
     			 return;
    		}

    	printf("%s ", node->value );
    
   	 return;

  	}	

  	if(node->token == Tnotleaf){

    		if(node->children == NULL){
      			printf("ERROR 3\n");
      			return;
    		}

    		node_t * aux = node->children;

    		while(aux != NULL){
      			print_tree(aux);
      			aux = aux->next;
    		}
  	}
}

void print_headers(){
	printf("#include <stdio.h>\n");
	printf("#include <stdlib.h>\n");
}