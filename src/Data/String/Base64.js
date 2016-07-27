"use strict";

var atobIsDefined = typeof atob === "function";
var btoaIsDefined = typeof btoa === "function";

// This function converts a `Uint8Array` to a btoa-safe string.
// It does so by treating each byte as a Unicode code point value and by
// concatenating the corresponding characters.
// This means that e.g. a three-byte UTF-8 character is mapped to three
// different characters with code points between 0 .. U+00FF.
// This is also the reason why `String.fromCharCode` is perfectly safe here.
function uint8ArrayToBtoaSafeString (u8) {
  var chunkSize = 0x8000; // Chunk size used for reading large arrays
  var cs = [];

  for (var i = 0; i < u8.length; i += chunkSize) {
    cs.push(String.fromCharCode.apply(null, u8.subarray(i, i + chunkSize)));
  }

  return cs.join("");
};

// Encode a string to its Base64 representation using Node's `Buffer` API
function encodeNode (str) {
  var base64EncodedString = Buffer.from(str).toString("base64");

  return base64EncodedString;
};

// Decode a Base64-encoded string using Node's `Buffer` API
function _decodeNode (Left, Right, str) {
  var result;

  // Check that the input string is a valid Base64-encoded string as Node.js
  // decided that it would be a good idea to NOT throw on invalid input strings
  // but return an empty buffer instead which cannot be distinguished from the
  // empty string case.
  var reEmptyString = "^$";
  var leadingQuanta = "^([A-Za-z0-9+/]{4})*";
  var finalQuantum =
    "([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}(?:=)?|[A-Za-z0-9+/]{2}(?:=){0,2})$";
  var reValidBase64 =
    new RegExp([reEmptyString, "|", leadingQuanta, finalQuantum].join(""));

  try {
    if (!reValidBase64.test(str)) { throw new Error("Invalid input string");}
    result = Right(Buffer.from(str, "base64").toString("utf-8"));
  }
  catch (error) {
    result = Left(error);
  }

  return result;
};

function _atob (Left, Right, str) {
  var result;

  try {
    result = Right(atob(str));
  }
  catch (error) {
    result = Left(error);
  }

  return result;
};

function _btoa (Left, Right, str) {
  var result;

  try {
    result = Right(btoa(str));
  }
  catch (error) {
    result = Left(error);
  }

  return result;
};

exports.atobIsDefined              = atobIsDefined;
exports.btoaIsDefined              = btoaIsDefined;
exports.uint8ArrayToBtoaSafeString = uint8ArrayToBtoaSafeString;
exports.encodeNode                 = encodeNode;
exports._decodeNode                = _decodeNode;
exports._atob                      = _atob;
exports._btoa                      = _btoa;
