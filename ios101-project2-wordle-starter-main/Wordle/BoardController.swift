//
//  BoardController.swift
//  Wordle
//
//  Created by Mari Batilando on 2/20/23.
//

import Foundation
import UIKit

class BoardController: NSObject,
                       UICollectionViewDataSource,
                       UICollectionViewDelegate,
                       UICollectionViewDelegateFlowLayout {
  
  // MARK: - Properties
  var numItemsPerRow = 5
  var numRows = 6
  let collectionView: UICollectionView
  var goalWord: [String]

  var numTimesGuessed = 0
  var isAlienWordle = false
  var currRow: Int {
    return numTimesGuessed / numItemsPerRow
  }
  
  init(collectionView: UICollectionView) {
    self.collectionView = collectionView
    let rawTheme = SettingsManager.shared.settingsDictionary[kWordThemeKey] as! String
    let theme = WordTheme(rawValue: rawTheme)!
    self.goalWord = WordGenerator.generateGoalWord(with: theme)
    super.init()
    collectionView.delegate = self
    collectionView.dataSource = self
  }
  
  // MARK: - Public Methods
  func resetBoard(with settings: [String: Any]) {
    applyNumLettersSettings(with: settings)
    applyNumGuessesSettings(with: settings)
    applyThemeSettings(with: settings)
    applyIsAlienWordleSettings(with: settings)
    numTimesGuessed = 0
    collectionView.reloadData()
  }
  
  func resetBoardWithCurrentSettings() {
    // Resets the board without changing the goal word
    numTimesGuessed = 0
    collectionView.reloadData()
  }
  
  private func applyNumLettersSettings(with settings: [String: Any]) {
    if let numLetters = settings[kNumLettersKey] as? Int {
      numItemsPerRow = numLetters
    }
  }
  
  private func applyNumGuessesSettings(with settings: [String: Any]) {
    if let numGuesses = settings[kNumGuessesKey] as? Int {
      numRows = numGuesses
    }
  }
  
  private func applyThemeSettings(with settings: [String: Any]) {
    if let rawTheme = settings[kWordThemeKey] as? String,
       let theme = WordTheme(rawValue: rawTheme) {
      goalWord = WordGenerator.generateGoalWord(with: theme)
    }
  }
  
  private func applyIsAlienWordleSettings(with settings: [String: Any]) {
    if let isAlien = settings[kIsAlienWordleKey] as? Bool {
      isAlienWordle = isAlien
    }
  }
  
  // MARK: - UICollectionView DataSource
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return numItemsPerRow * numRows
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LetterCell", for: indexPath) as! LetterCell
    cell.configure(with: "")
    return cell
  }
  
  // MARK: - UICollectionViewDelegateFlowLayout
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let padding: CGFloat = 5
    let totalPadding = padding * CGFloat(numItemsPerRow - 1)
    let width = (collectionView.frame.width - totalPadding) / CGFloat(numItemsPerRow)
    return CGSize(width: width, height: width)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 5
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 5
  }
}

