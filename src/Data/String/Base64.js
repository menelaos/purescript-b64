export function atobImpl (Left, Right, str) {
  let result;

  try {
    result = Right(atob(str));
  }
  catch (error) {
    result = Left(error);
  }

  return result;
};

export function btoaImpl (Left, Right, str) {
  let result;

  try {
    result = Right(btoa(str));
  }
  catch (error) {
    result = Left(error);
  }

  return result;
};
