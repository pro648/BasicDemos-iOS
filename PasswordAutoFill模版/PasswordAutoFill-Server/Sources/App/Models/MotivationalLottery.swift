/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Vapor
import Crypto

struct MotivationalLottery: Content {
  let motivation: String
  
  init() {
    let motivationalQuotes = ["\"If you want to build a ship, don't drum up the people to gather wood, divide the work, and give orders. Instead, teach them to yearn for the vast and endless sea.\"\n- Antoine de Saint-Exupery", "\"Life is 10% what happens to you and 90% how you react to it.\"\n- Charles R. Swindoll", "\"You will never win if you never begin.\"\n- Helen Rowland", "\"Accept the challenges so that you can feel the exhilaration of victory.\"\n- George S. Patton", "\"Without hard work, nothing grows but weeds.\"\n- Gordon B. Hinckley", "\"If you fell down yesterday, stand up today.\"\n- H. G. Wells", "\"Setting goals is the first step in turning the invisible into the visible.\"\n- Tony Robbins", "\"Perseverance is not a long race; it is many short races one after the other.\"\n- Walter Elliot", "\"Well done is better than well said.\"\n- Benjamin Franklin", "\"The key is to keep company only with people who uplift you, whose presence calls forth your best.\"\n- Epictetus", "\"We have two ears and one mouth so that we can listen twice as much as we speak.\"\n- Epictetus", "\"Look up at the stars and not down at your feet. Try to make sense of what you see, and wonder about what makes the universe exist. Be curious.\"\n- Stephen Hawking", "\"Ever tried. Ever failed. No matter. Try Again. Fail again. Fail better.\"\n- Samuel Beckett", "\"Do the difficult things while they are easy and do the great things while they are small. A journey of a thousand miles must begin with a single step.\"\n- Lao Tzu", "\"Even if you are on the right track, you’ll get run over if you just sit there.\"\n– Will Rogers", "\"If you think you are too small to make a difference, try sleeping with a mosquito.\"\n– Dalai Lama", "\"I didn’t fail the test. I just found 100 ways to do it wrong.\"\n– Benjamin Franklin", "\"The road to success is dotted with many tempting parking spaces.\"\n– Will Rogers", "\"Tough times never last, but tough people do.\"\n- Robert H. Schuller", "\"When you want to succeed as bad as you want to breathe,then you’ll be successful.\"\n- Eric Thomas", "\"Hard work beats talent when talent doesn’t work hard.\"\n- Tim Notke", "\"The greatest pleasure in life is doing what people say you cannot do.\"\n- Walter Bagehot", "\"Remember that not getting what you want is sometimes a wonderful stroke of luck.\"\n- Dalai Lama", "\"The whole secret of a successful life is to find out what is one’s destiny to do, and then do it.\"\n- Henry Ford", "\"Too many of us are not living our dreams because we are living our fears.\"- Les Brown", "\"It’s not about time, it’s about choices. How are you spending your choices?\"- Beverly Abamo", "\"You will succeed because most people are lazy.\"\n- Unknown", "\"If you want to achieve greatness stop asking for permission.\"\n- Unknown", "\"You can never cross the ocean unless you have the courage to lose sight of the shore.\"\n- Christopher Columbus", "\"Some people develop a wish bone where their back bone should be.\"\n- Unknown"]
     do {
      let index = try abs(CryptoRandom().generate()) % motivationalQuotes.count
      motivation = motivationalQuotes[index]
     } catch {
      motivation = motivationalQuotes[0]
    }
  }
}

