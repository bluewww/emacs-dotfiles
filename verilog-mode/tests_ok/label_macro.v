// Bug 859 -- 'end' should label after a user/library-defined macro
// that isn't terminated with a semi-colon
class c;
   
   `uvm_info(get_type_name(), "Digital power up.", UVM_MEDIUM)
   
   fork
      begin
      end // fork begin
   join
   
   `made_up_macro (a, \
                   b, \
                   c)
   begin: named_block
   end // block: named_block
   
endclass // c

// Local Variables:
// verilog-minimum-comment-distance: 1
// verilog-auto-endcomments: t
// verilog-indent-ignore-multiline-defines: nil
// End:
