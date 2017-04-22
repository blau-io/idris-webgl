--    Copyright 2017, the blau.io contributors
--
--    Licensed under the Apache License, Version 2.0 (the "License");
--    you may not use this file except in compliance with the License.
--    You may obtain a copy of the License at
--
--        http://www.apache.org/licenses/LICENSE-2.0
--
--    Unless required by applicable law or agreed to in writing, software
--    distributed under the License is distributed on an "AS IS" BASIS,
--    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--    See the License for the specific language governing permissions and
--    limitations under the License.

module API.WebGL.Context

import IdrisScript

%access public export
%default total

||| The WebGLRenderingContext represents the API allowing OpenGL ES 2.0 style
||| rendering into the canvas element.
|||
||| The original specification can be found at
||| https://www.khronos.org/registry/webgl/specs/latest/1.0/#WebGLRenderingContextBase
record WebGLRenderingContextBase where
  constructor New
  ||| A reference to the canvas element which created this context.
  canvas              : Ptr
  ||| The actual width of the drawing buffer. May be different from the width
  ||| attribute of the HTMLCanvasElement if the implementation is unable to
  ||| satisfy the requested widthor height.
  drawingBufferWidth  : Int
  ||| The actual height of the drawing buffer. May be different from the height
  ||| attribute of the HTMLCanvasElement if the implementation is unable to
  ||| satisfy the requested width or height.
  drawingBufferHeight : Int
  ||| A non standard field for easier JS integration
  self                : Ptr

COLOR_BUFFER_BIT : Int
COLOR_BUFFER_BIT = 0x00004000

DEPTH_BUFFER_BIT : Int
DEPTH_BUFFER_BIT = 0x00000100

STENCIL_BUFFER_BIT : Int
STENCIL_BUFFER_BIT = 0x00000400

||| clears a buffer
-- TODO: Proper type for GLbitfield
clear : WebGLRenderingContextBase -> (buffer : Int) -> JS_IO ()
clear ctx = jscall "%0.clear(%1)" (JSRef -> Int -> JS_IO ()) $ self ctx

||| clearColor sets the clear value of the color buffer.
-- TODO: Proper Type for clampf
clearColor : WebGLRenderingContextBase -> (red : Double) -> (green : Double) ->
             (blue : Double) -> (alpha : Double) -> JS_IO ()
clearColor ctx = jscall "%0.clearColor(%1, %2, %3, %4)"
  (JSRef -> Double -> Double -> Double -> Double -> JS_IO ()) $ self ctx

WebGLRenderingContext : Type
WebGLRenderingContext = WebGLRenderingContextBase

||| webGlRenderingContextFromPointer is a helper function for easily creating
||| WebGLRenderingContexts from JavaScript references.
webGlRenderingContextFromPointer : JSRef -> JS_IO $ Maybe WebGLRenderingContext
webGlRenderingContextFromPointer ref = let
    canvas   = jscall "%0.canvas"              (JSRef -> JS_IO JSRef) ref
    dbWidth  = jscall "%0.drawingBufferWidth"  (JSRef -> JS_IO JSRef) ref
    dbHeight = jscall "%0.drawingBufferHeight" (JSRef -> JS_IO JSRef) ref
  in
    case !(IdrisScript.pack !dbWidth) of
      (JSNumber ** w) => case !(IdrisScript.pack !dbHeight) of
        (JSNumber ** h) => map Just $ New <$> canvas <*>
                                              pure (fromJS w) <*>
                                              pure (fromJS h) <*>
                                              pure ref
        _               => pure Nothing
      _               => pure Nothing
