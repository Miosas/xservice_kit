/*
 * Copyright (C) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * Type conversion utility class
 * Provides bidirectional conversion between Map and Record
 * @class XConverter
 */
export class XConverter {
  /**
   * Convert Map<string, Object> to Record<string, Object>
   * Supports recursive conversion of nested Map structures
   *
   * @static
   * @param {Map<string, Object>} map - The Map object to convert
   * @returns {Record<string, Object>} The converted Record object
   *
   * @example
   * const map = new Map([
   *   ['name', 'John'],
   *   ['data', new Map([['age', 25]])]
   * ]);
   * const record = XConverter.mapToRecord(map);
   * // Output: { name: 'John', data: { age: 25 } }
   */
  static mapToRecord(map: Map<string, Object>): Record<string, Object> {
    // Initialize empty Record object
    let rec: Record<string, Object> = {};

    // Iterate through each key-value pair in the Map
    map.forEach((val, key) => {
      // If the current value is a Map instance, recursively convert it
      if (val instanceof Map) {
        const _map = val as Map<string, Object>;
        const _rec = XConverter.mapToRecord(_map);
        rec[key] = _rec;
        return;
      }

      // Directly assign non-Map type values
      rec[key] = val;
    });

    return rec;
  }

  /**
   * Convert Record<string, Object> to Map<string, Object>
   * Note: This method only performs one-level conversion and does not recursively convert nested Records
   *
   * @static
   * @param {Record<string, Object>} rec - The Record object to convert
   * @returns {Map<string, Object>} The converted Map object
   *
   * @example
   * const record = { name: 'John', age: 25 };
   * const map = XConverter.recordToMap(record);
   * // Output: Map { 'name' => 'John', 'age' => 25 }
   */
  static recordToMap(rec: Record<string, Object>): Map<string, Object> {
    // Initialize new Map object
    let map: Map<string, Object> = new Map();

    // Get all key-value pairs array of the Record
    const recArr = Object.entries(rec);

    // Iterate through and set to Map
    recArr.forEach((item) => {
      map.set(item[0], item[1]);
    });

    return map;
  }
}