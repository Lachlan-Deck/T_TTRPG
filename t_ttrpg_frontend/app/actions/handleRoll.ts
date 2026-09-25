// app/actions/handleRoll.ts
"use server";

import { error } from "console";
import { attemptToUpgradeSegmentFromBFCache } from "next/dist/client/components/segment-cache/cache";

interface RollData {
  roll: String[];
}


type RollReturnState =
  | { sucess: true; data: {roll: string[]}}
  | { sucess: false; error: string };
  
type RollInputValue =
  | { sucess: true; rollString: string }
  | { sucess: false; error: string };

  
export async function handleRoll(formData: FormData): Promise<RollReturnState> {
  const formValue = formData.get("rollBox");

  const rollString: RollInputValue = typeof formValue
    === "string"
    && formValue.trim().length > 0
    ? {sucess: true, rollString: formValue}
    : {sucess: false, error: "Invalid input: 'rollBox' must be a non-empty string."}
   
  var returnState: RollReturnState =
  {sucess: false, error: "refused to try because: ", rollString.error}
  
  if (!rollString.sucess) {
    return
  }
  const query = `{roll(tokens: "${rollString}")}`;

  const variables = {
    tokens: rollString,
  };
  try {
    const response = await fetch("http://localhost:8088/graphql/", {
      method: "POST",
      headers: {
        "Content-Type": "Application/json",
      },
      body: JSON.stringify({ query, variables }),
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
