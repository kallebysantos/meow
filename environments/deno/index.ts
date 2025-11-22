console.log("Meow!!");

async function fetch(req) {
  console.log(req);
  return Response.json({ meow: "meow!" });
}

export default { fetch };
