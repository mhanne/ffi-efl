#! /usr/bin/env ruby
# -*- coding: UTF-8 -*-
#
require 'efl/native'
require 'efl/native/elementary'
#
module Efl
    #
    module ElmCursor
        #
        FCT_PREFIX = 'elm_cursor_' unless const_defined? :FCT_PREFIX
        #
        def self.method_missing meth, *args, &block
            sym = Efl::MethodResolver.resolve self, meth, FCT_PREFIX
            self.send sym, *args, &block
        end
        #
    end
    #
    module Native
        #
        ffi_lib 'elementary-ver-pre-svn-09.so.0'
        #
        # FUNCTIONS
        fcts = [
        # EAPI void elm_object_cursor_set(Evas_Object *obj, const char *cursor);
        [ :elm_object_cursor_set, [ :evas_object, :string ], :void ],
        # EAPI const char *elm_object_cursor_get(const Evas_Object *obj);
        [ :elm_object_cursor_get, [ :evas_object ], :string ],
        # EAPI void elm_object_cursor_unset(Evas_Object *obj);
        [ :elm_object_cursor_unset, [ :evas_object ], :void ],
        # EAPI void elm_object_cursor_style_set(Evas_Object *obj, const char *style);
        [ :elm_object_cursor_style_set, [ :evas_object, :string ], :void ],
        # EAPI const char *elm_object_cursor_style_get(const Evas_Object *obj);
        [ :elm_object_cursor_style_get, [ :evas_object ], :string ],
        # EAPI void elm_object_cursor_engine_only_set(Evas_Object *obj, Eina_Bool engine_only);
        [ :elm_object_cursor_engine_only_set, [ :evas_object, :bool ], :void ],
        # EAPI Eina_Bool elm_object_cursor_engine_only_get(const Evas_Object *obj);
        [ :elm_object_cursor_engine_only_get, [ :evas_object ], :bool ],
        # EAPI int elm_cursor_engine_only_get(void);
        [ :elm_cursor_engine_only_get, [  ], :int ],
        # EAPI Eina_Bool elm_cursor_engine_only_set(int engine_only);
        [ :elm_cursor_engine_only_set, [ :int ], :bool ],
        ]
        #
        attach_fcts fcts
        #
    end
end
#
# EOF
