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

      klass.add_method 'xine_init', 'void', 'init' do |method|
        method.add_instance_parameter
      end

      klass.add_method 'xine_open_audio_driver', 'xine_audio_port_t*',
                       'open_audio_driver' do |method|
        method.add_instance_parameter
        method.add_parameter 'char*', 'id'
        method.add_parameter_default 'void*', 'data', 'NULL'
      end

      klass.add_method 'xine_open_video_driver', 'xine_video_port_t*',
                       'open_video_driver' do |method|
        method.add_instance_parameter
        method.add_parameter 'char*', 'id'
        method.add_parameter 'xine_t::Visual::Visual', 'visual'
        method.add_parameter_default 'void*', 'data', 'NULL'
      end

      klass.add_cleanup_function 'xine_exit((xine_t*)p)'
    end

    ns.add_class_wrapper 'AudioPort', 'xine_audio_port_t' do |klass|
      klass.add_method 'xine_close_audio_driver', 'void', 'close' do |method|
        method.add_parameter 'xine_t*', 'parent_instance'
        method.add_instance_parameter
        # Note: we should find a way to save the parent xine instance
        # and pass it automatically.
      end
    end

    ns.add_class_wrapper 'VideoPort', 'xine_video_port_t' do |klass|
      klass.add_method 'xine_close_video_driver', 'void', 'close' do |method|
        method.add_parameter 'xine_t*', 'parent_instance'
        method.add_instance_parameter
        # Note: we should find a way to save the parent xine instance
        # and pass it automatically.
      end

      klass.add_namespace 'Visual', '' do |visual|
        visual.add_enum 'Visual', 'int' do |enum|
          enum.add_value 'None', 'XINE_VISUAL_TYPE_NONE'
          enum.add_value 'X11', 'XINE_VISUAL_TYPE_X11'
          enum.add_value 'X11_2', 'XINE_VISUAL_TYPE_X11_2'
          enum.add_value 'AA', 'XINE_VISUAL_TYPE_AA'
          enum.add_value 'FB', 'XINE_VISUAL_TYPE_FB'
          enum.add_value 'Gtk', 'XINE_VISUAL_TYPE_GTK'
          enum.add_value 'DFB', 'XINE_VISUAL_TYPE_DFB'
          enum.add_value 'PM', 'XINE_VISUAL_TYPE_PM'
          enum.add_value 'DirectX', 'XINE_VISUAL_TYPE_DIRECTX'
          enum.add_value 'Caca', 'XINE_VISUAL_TYPE_CACA'
          enum.add_value 'MacOSX', 'XINE_VISUAL_TYPE_MACOSX'
          enum.add_value 'XCB', 'XINE_VISUAL_TYPE_XCB'
        end
      end
    end

    ns.add_class_wrapper 'Stream', 'xine_stream_t' do |klass|
      klass.add_constructor 'xine_stream_new' do |method|
        method.add_parameter 'xine_t*', 'xine'
        method.add_parameter 'xine_audio_port_t*', 'ao'
        method.add_parameter 'xine_video_port_t*', 'vo'
      end
    end

  end
end
