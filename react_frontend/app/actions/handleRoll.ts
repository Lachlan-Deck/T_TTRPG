// app/actions/handleRoll.ts
"use server";

import { error } from "console";

interface RollData {
  roll: String[];
}

export type RollReturnState =
  | { success: true; data: { roll: RollData } }
  | { success: false; error: string };

export async function handleRoll(
  prevState: RollReturnState,
  formData: FormData,
): Promise<RollReturnState> {
  const BASEURL = "http://localhost:8088/graphql/";
  const formValue = formData.get("rollBox");

  if (typeof formValue !== "string" || formValue.trim().length === 0) {
    return {
      success: false,
      error: "rollBox must contain a non empty string",
    };
  }

  const rollString = formValue;
  const query = `{roll(tokens: "${rollString}")}`;

  try {
    const response = await fetch(BASEURL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ query }),
    });

    const result = await response.json();

    if (result.errors && result.errors.length > 0) {
      return {
        success: false,
        error: result.error[0].message,
      };
    }
    return {
      success: true,
      data: result.data,
    };
  } catch (error: unknown) {
    const errorMessage =
      error instanceof Error ? error.message : "An unknown error occurred";
    console.error("ERROR: calling graphQL: ", error);
    return {
      success: false,
      error: errorMessage,
    };
  }
}
