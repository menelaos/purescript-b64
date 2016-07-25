"use strict";

// Chunk size used for reading large arrays
var chunkSize = 0x8000;

// This function converts a `Uint8Array` to a btoa-safe string.
// It does so by treating each byte as a Unicode code point value and by
// concatenating the corresponding characters.
// This means that e.g. a three-byte UTF-8 character is mapped to three
// different characters with code points between U+0000 .. U+00FF.
// This is also the reason why `String.fromCharCode` is perfectly safe here.
exports.uint8ArrayToBtoaSafeString = function (u8) {
  var cs = [];

  for (var i = 0; i < u8.length; i += chunkSize) {
    cs.push(String.fromCharCode.apply(null, u8.subarray(i, i + chunkSize)));
  }

  return cs.join("");
};

exports._atob = function (Left, Right, str) {
  var result;

  try {
    result = Right(atob(str));
  }
  catch (error) {
    result = Left(error);
  }

  return result;
};

exports._btoa = function (Left, Right, str) {
  var result;

  try {
    result = Right(btoa(str));
  }
  catch (error) {
    result = Left(error);
  }

  return result;
};
