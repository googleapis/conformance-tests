// Copyright 2019, Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
 
using Google.Protobuf;
using System;
using System.IO;

using Storage.V1.Tests;

public class Program
{
    static int Main(string[] args)
    {
        int result = 0;
        
        foreach (var file in args)
        {
            Console.WriteLine($"Validating {file}");
            try
            {
                string json = File.ReadAllText(file);
                TestFile.Parser.ParseJson(json);
            }
            catch (Exception e)
            {
                Console.WriteLine($"Error: {e.GetType().Name}: {e.Message}");
                result = 1;
            }
        }
        return result;
    }
}