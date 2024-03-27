ARCHITECTURE masterVersion OF resizer IS

BEGIN

  outGtIn: if resizeOut'length > resizeIn'length generate
  begin
    resizeOut <= shift_left(
      resize(
        resizeIn,
        resizeOut'length
      ),
      resizeOut'length-resizeIn'length
    );
  end generate outGtIn;

  outEqIn: if resizeOut'length = resizeIn'length generate
  begin
    resizeOut <= resizeIn;
  end generate outEqIn;

  outLtIn: if resizeOut'length < resizeIn'length generate
  begin
    resizeOut <= resize(
      shift_right(
        resizeIn,
        resizeIn'length-resizeOut'length
      ),
      resizeOut'length
    );
  end generate outLtIn;

END ARCHITECTURE masterVersion;

