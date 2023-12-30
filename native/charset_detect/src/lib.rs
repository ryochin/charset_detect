use rustler::{Binary, OwnedBinary, NifResult};

use chardetng::EncodingDetector;
use encoding_rs::Encoding;

#[rustler::nif(schedule = "DirtyCpu")]
fn _guess(body: Binary) -> NifResult<OwnedBinary> {
    let mut detector = EncodingDetector::new();
    detector.feed(&body, true);
    let encoding: &Encoding = detector.guess(None, true);
    let name: &str = encoding.name();

    let mut binary: OwnedBinary = OwnedBinary::new(name.len())
        .ok_or_else(|| err_str("failed to allocate binary".to_string()))?;

    binary.as_mut_slice().copy_from_slice(name.as_bytes());

    Ok(binary)
}

fn err_str(error: String) -> rustler::Error {
    rustler::Error::Term(Box::new(error))
}

rustler::init!("Elixir.CharsetDetect", [_guess]);
