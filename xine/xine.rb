#  ruby-xine - Ruby bindings for xine library
#  Copyright (C) 2007, Diego Pettenò
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this software; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

require 'rust'

Rust::Bindings::create_bindings Rust::Bindings::LangCxx, "xine" do |b|
  b.include_header 'xine.h'

  b.add_namespace 'Xine', '' do |ns|
    ns.add_function 'xine_get_version_string', 'const char *', 'get_version_string'
    ns.add_function 'xine_get_version', 'void', 'get_version' do |funct|
      funct.set_custom('VALUE !function_varname!(VALUE self)',
                       "VALUE !function_varname!(VALUE self) {
                         int version[3];
                         
                         xine_get_version(&version[0], &version[1], &version[2]);
                         return rb_ary_new3(3, INT2FIX(version[0]),
                                               INT2FIX(version[1]),
                                               INT2FIX(version[2]) );
                       }
                       ")
    end

    ns.add_constant 'MajorVersion', 'XINE_MAJOR_VERSION'
    ns.add_constant 'MinorVersion', 'XINE_MINOR_VERSION'
    ns.add_constant 'SubVersion', 'XINE_SUB_VERSION'
    ns.add_constant 'Version', 'XINE_VERSION'

    ns.add_class_wrapper 'Xine', 'xine_t' do |klass|
      klass.add_constructor 'xine_new'
    end

  end
end
