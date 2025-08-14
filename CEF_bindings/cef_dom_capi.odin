package odin_cef

import "core:c"

cef_domvisitor_t :: struct {
	base: base_ref_counted,
	visit: proc "c" (self: ^cef_domvisitor_t, document: ^cef_domdocument_t),
}

cef_domdocument_t :: struct {
	base: base_ref_counted,
	
	get_type: proc "c" (self: ^cef_domdocument_t) -> cef_dom_document_type_t,
	get_document: proc "c" (self: ^cef_domdocument_t) -> ^cef_domnode_t,
	get_body: proc "c" (self: ^cef_domdocument_t) -> ^cef_domnode_t,
	get_head: proc "c" (self: ^cef_domdocument_t) -> ^cef_domnode_t,
	get_title: proc "c" (self: ^cef_domdocument_t) -> cef_string_userfree,
	get_element_by_id: proc "c" (self: ^cef_domdocument_t, id: ^cef_string) -> ^cef_domnode_t,
	get_focused_node: proc "c" (self: ^cef_domdocument_t) -> ^cef_domnode_t,
	has_selection: proc "c" (self: ^cef_domdocument_t) -> b32,
	get_selection_start_offset: proc "c" (self: ^cef_domdocument_t) -> c.int,
	get_selection_end_offset: proc "c" (self: ^cef_domdocument_t) -> c.int,
	get_selection_as_markup: proc "c" (self: ^cef_domdocument_t) -> cef_string_userfree,
	get_selection_as_text: proc "c" (self: ^cef_domdocument_t) -> cef_string_userfree,
	get_base_url: proc "c" (self: ^cef_domdocument_t) -> cef_string_userfree,
	get_complete_url: proc "c" (self: ^cef_domdocument_t, partial_url: ^cef_string) -> cef_string_userfree,
}

cef_domnode_t :: struct {
	base: base_ref_counted,
	
	get_type: proc "c" (self: ^cef_domnode_t) -> cef_dom_node_type_t,
	is_text: proc "c" (self: ^cef_domnode_t) -> b32,
	is_element: proc "c" (self: ^cef_domnode_t) -> b32,
	is_editable: proc "c" (self: ^cef_domnode_t) -> b32,
	is_form_control_element: proc "c" (self: ^cef_domnode_t) -> b32,
	get_form_control_element_type: proc "c" (self: ^cef_domnode_t) -> cef_dom_form_control_type_t,
	is_same: proc "c" (self: ^cef_domnode_t, that: ^cef_domnode_t) -> b32,
	get_name: proc "c" (self: ^cef_domnode_t) -> cef_string_userfree,
	get_value: proc "c" (self: ^cef_domnode_t) -> cef_string_userfree,
	set_value: proc "c" (self: ^cef_domnode_t, value: ^cef_string) -> b32,
	get_as_markup: proc "c" (self: ^cef_domnode_t) -> cef_string_userfree,
	get_document: proc "c" (self: ^cef_domnode_t) -> ^cef_domdocument_t,
	get_parent: proc "c" (self: ^cef_domnode_t) -> ^cef_domnode_t,
	get_previous_sibling: proc "c" (self: ^cef_domnode_t) -> ^cef_domnode_t,
	get_next_sibling: proc "c" (self: ^cef_domnode_t) -> ^cef_domnode_t,
	has_children: proc "c" (self: ^cef_domnode_t) -> b32,
	get_first_child: proc "c" (self: ^cef_domnode_t) -> ^cef_domnode_t,
	get_last_child: proc "c" (self: ^cef_domnode_t) -> ^cef_domnode_t,
	get_element_tag_name: proc "c" (self: ^cef_domnode_t) -> cef_string_userfree,
	has_element_attributes: proc "c" (self: ^cef_domnode_t) -> b32,
	has_element_attribute: proc "c" (self: ^cef_domnode_t, attr_name: ^cef_string) -> b32,
	get_element_attribute: proc "c" (self: ^cef_domnode_t, attr_name: ^cef_string) -> cef_string_userfree,
	get_element_attributes: proc "c" (self: ^cef_domnode_t, attr_map: cef_string_map_t),
	set_element_attribute: proc "c" (self: ^cef_domnode_t, attr_name: ^cef_string, value: ^cef_string) -> b32,
	get_element_inner_text: proc "c" (self: ^cef_domnode_t) -> cef_string_userfree,
	get_element_bounds: proc "c" (self: ^cef_domnode_t) -> cef_rect,
} 