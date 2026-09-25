// app/actions/handleRoll.ts
"use server";
export async function handleRoll(formData) {
  formData.preventDefault();

  const rollString = formData.get("rollBox");

  const query = `
      {
        "query": "query { roll(tokens: $input: rollString) }"
      }
      
    `;
  const inputVar = {
    input: { rollString },
  };
  try {
    const response = await fetch("http://localhost:8088/graphql/", {
      method: "GET",
      headers: {
        "Content-Type": "Application/json",
      },
      body: JSON.stringify({ query, inputVar }),
    });

    const result = await response.json();

    if (result.errors) {
      throw new Error(result.errors[0].message);
    }

    return { sucess: true, data: result.data };
  } catch (error) {
    console.error("ERROR calling graphQL: ", error);
    return { success: false, error: error.message };
  }
}
