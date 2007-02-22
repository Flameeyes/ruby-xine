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

      ns.add_method 'xine_init', 'void', 'init' do |method|
        method.add_instance_parameter
      end

      ns.add_method 'open_audio_port', 'xine_audio_port_t*' do |method|
        method.add_instance_parameter
        method.add_parameter 'char*', 'id'
        method.add_parameter_default 'NULL'
      end

      ns.add_method 'open_video_port', 'xine_video_port_t*' do |method|
        method.add_instance_parameter
        method.add_parameter 'char*', 'id'
        method.add_parameter 'int', 'visual' # This should be a
                                             # virtual enum
        method.add_parameter_default 'NULL'
      end

      klass.add_cleanup_function 'xine_exit(p)'
    end

    ns.add_class_wrapper 'AudioPort', 'xine_audio_port_t' do |klass|
      klass.add_method 'close' do |method|
        method.add_parameter 'xine_t*', 'parent_insatnce'
        method.add_instance_parameter
        # Note: we should find a way to save the parent xine instance
        # and pass it automatically.
      end
    end

    ns.add_class_wrapper 'VideoPort', 'xine_video_port_t' do |klass|
      klass.add_method 'close' do |method|
        method.add_parameter 'xine_t*', 'parent_insatnce'
        method.add_instance_parameter
        # Note: we should find a way to save the parent xine instance
        # and pass it automatically.
      end

      klass.add_constant 'VisualNone', 'XINE_VISUAL_TYPE_NONE'
      klass.add_constant 'VisualX11', 'XINE_VISUAL_TYPE_X11'
      klass.add_constant 'VisualX11_2', 'XINE_VISUAL_TYPE_X11_2'
      klass.add_constant 'VisualAA', 'XINE_VISUAL_TYPE_AA'
      klass.add_constant 'VisualFB', 'XINE_VISUAL_TYPE_FB'
      klass.add_constant 'VisualGtk', 'XINE_VISUAL_TYPE_GTK'
      klass.add_constant 'VisualDFB', 'XINE_VISUAL_TYPE_DFB'
      klass.add_constant 'VisualPM', 'XINE_VISUAL_TYPE_PM'
      klass.add_constant 'VisualDirectX', 'XINE_VISUAL_TYPE_DIRECTX'
      klass.add_constant 'VisualCaca', 'XINE_VISUAL_TYPE_CACA'
      klass.add_constant 'VisualMacOSX', 'XINE_VISUAL_TYPE_MACOSX'
      klass.add_constant 'VisualXCB', 'XINE_VISUAL_TYPE_XCB'
    end

    ns.add_class_wrapper 'Stream', 'xine_stream_t' do |klass|
      ns.add_constructor 'xine_stream_new' do |method|
        method.add_parameter 'xine_t*', 'xine'
        method.add_parameter 'xine_audio_port_t*', 'ao'
        method.add_parameter 'xine_video_port_t*', 'vo'
      end
    end

  end
end
