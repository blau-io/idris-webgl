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

module API.WebGL.Buffer

import IdrisScript

%access public export
%default total

record WebGLBuffer where
  constructor New
  self : JSRef

ARRAY_BUFFER : Int
ARRAY_BUFFER = 0x8892

STATIC_DRAW : Int
STATIC_DRAW = 0x88E4

