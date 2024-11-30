use rustler::types::tuple::make_tuple;
use rustler::{Binary, Encoder, Env, NifResult, OwnedBinary, Term};

use chardetng::EncodingDetector;
use encoding_rs::Encoding;

mod atoms {
    rustler::atoms! {
        ok
    }
}

#[rustler::nif(schedule = "DirtyCpu")]
fn _guess<'a>(env: Env<'a>, body: Binary<'a>) -> NifResult<Term<'a>> {
    let mut detector = EncodingDetector::new();
    detector.feed(&body, true);
    let encoding: &Encoding = detector.guess(None, true);
    let name: &str = encoding.name();

    let mut binary: OwnedBinary = OwnedBinary::new(name.len())
        .ok_or_else(|| err_str("failed to allocate binary".to_string()))?;

    binary.as_mut_slice().copy_from_slice(name.as_bytes());

    let ok = atoms::ok().encode(env);

    Ok(make_tuple(env, &[ok, binary.release(env).encode(env)]))
}

fn err_str(error: String) -> rustler::Error {
    rustler::Error::Term(Box::new(error))
}

rustler::init!("Elixir.CharsetDetect");
